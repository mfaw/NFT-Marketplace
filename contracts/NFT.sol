// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721{
    // a constructor requires a name and a symbol of the ERC721 token
    constructor() ERC721("My cool NFT", "NFT") {}

    uint private _tokenId = 0;

    // must have a mint function
    function mint() external returns (uint){
        _tokenId++;
        // the NFT is minted to the person calling this function
        _mint(msg.sender, _tokenId);
        return _tokenId;
    }

}