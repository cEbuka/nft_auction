// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ERC721 NFT Contract
contract NFT is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    constructor() ERC721("Baby Sharks", "BSS") Ownable(msg.sender) {}

    // Mint function to create new NFTs
    function safeMint(address to, string memory tokenURI) external onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        _tokenIdCounter++;
    }
}
