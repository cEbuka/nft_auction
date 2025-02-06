// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTAuction {
    ERC721 public nftContract;

    struct Auction {
        address seller;
        uint256 tokenId;
        uint256 startPrice;
        uint256 endTime; // To be calculated from the duration
        address highestBidder;
        uint256 higestBid;
        bool active;
    }

    mapping(uint256 => Auction) public auctions;

    // Events
    event AuctionCreated(
        uint256 indexed tokenId,
        uint256 startPrice,
        uint256 endTime
    );
    event BidPlaced(uint256 tokenId, address bidder, uint256 amount);
    event AuctionFinalized(uint256 tokenId, address winner, uint256 amount);
    event AuctionCancelled(uint256 tokenId);

    constructor(address _nftContract) {
        nftContract = ERC721(_nftContract);
    }

    // Functions
    // create auction event
    function createAuction(
        uint256 _tokenId,
        uint256 _startPrice,
        uint256 _duration
    ) external {}

    // create bid
    function placeBid(uint256 _tokenId) external payable {}

    // auction finalized
    function finalizeAuction(uint256 _tokenId) external {}

    // auction cancelled
    function cancelAuction(uint256 _tokenId) external {}
}
