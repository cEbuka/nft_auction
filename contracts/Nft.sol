// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/draft/Counter.sol";

// ERC721 NFT Contract
contract NFT is ERC721Full, Ownable {
    using Counters for  Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721Full(name, symbol) Ownable(msg.sender) {}

    // Mint function to create new NFTs
    function safeMint(address to, string memory tokenURI) external onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI)
        _tokenIdCounter.increment();
    }

    // Function to get the current token ID count
    function getCurrentTokenId() external view returns (uint256) {
        return tokenIdCounter;
    }
}
