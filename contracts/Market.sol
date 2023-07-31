// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Market{
    // public - avaiable from anywhere like any contract or wallet
    // private - available in this smart contract only 
    // internal - only this contract and inheriting contracts
    // external - only external calls can use it

    enum ListingStatus{
        Active,
        Sold,
        Cancelled
    }

    
    // must have address of the seller for validation before buying
    struct Listing{
        ListingStatus status;
        address seller;
        address token;
        uint tokenId;
        uint price;
    }

    // mapping is like dict in python
    // takes an integer and matches it to a listing 
    // it will be stored forever
    uint private _listingId = 0;
    mapping(uint => Listing) private _listings;

    function listTokens(address token, uint tokenId, uint price) external{
        // this listing variable will stay in memory for the duration of the
        // function call
        // we will use msg.sender to get the actual person making this call because if 
        // we pass it like token, we can pass anything, this will also be the seller
        Listing memory listing = Listing(
            ListingStatus.Active,
            msg.sender,
            token, 
            tokenId, 
            price
        );

        // each listing should have a unique id so we will have an incremental counter
        _listingId ++;

        _listings[_listingId] = listing;

    }

    // which token they want to buy from the listingId
    // to accept payment, add payabale
    // payable allows sending ether to this function
    function buyToken(uint listingId) external payable{
        /* using storage creates a pointer to the mapping of listings created above
           using memory will copy the listings found in mapping in this variable and we
           can access it and make changes that won't reflect and won't persist in the actual 
           database like so */
        // Listing memory listing = _listings[listingId];
        // listing.price;
        // to apply the changes, must pass the listingId like so
        // _listings[listingId] = listing;

        // instead, just use storage to point to the mapping
        Listing storage listing = _listings[listingId];

        // check listing is active, instead of if block, use require
        // if (listing.status != ListingStatus.Active){
        //     // cancel everything that comes after and return error
        //     revert("Listing is not active");
        // }

        // anything after require if it's not satisfied won't be executed
        require(listing.status == ListingStatus.Active, "Listing is not active");
        // want to check the current buyer isn't the same as the seller of the token
        require(msg.sender != listing.seller, "Buyer can't be the seller");

        // msg.value is the amount of ether sent in this function call, wei currency
        // must check the amount of ether is greater than the price of the token 
        require(msg.value >= listing.price, "Insuffient amount");

        

    }

}

