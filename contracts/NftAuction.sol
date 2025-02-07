// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTAuction {
    ERC721 public nftContract;

    struct Auction {
        address payable seller;
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
    ) external {
        Auction storage auction = auctions[_tokenId];
        require(nftContract.ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(
            nftContract.getApproved(_tokenId) == address(this),
            "Must be approved to transfer NFT"
        );
        require(auction.active == false, "Auction already active");

        auctions[_tokenId] = Auction(
            payable(msg.sender),
            _tokenId,
            _startPrice,
            block.timestamp + _duration,
            address(0),
            0,
            true
        );

        emit AuctionCreated(_tokenId, _startPrice, block.timestamp + _duration);
    }

    // create bid
    function placeBid(uint256 _tokenId) external payable {
        Auction storage auction = auctions[_tokenId];
        require(auction.active == true, "Auction not active");
        require(block.timestamp < auction.endTime, "Auction ended");
        require(msg.value > auction.higestBid, "Bid too low");
        require(
            msg.value >= auction.startPrice,
            "Bid must be greater than start price"
        );

        if (auction.higestBid != 0) {
            payable(auction.highestBidder).transfer(auction.higestBid);
        }

        auction.highestBidder = msg.sender;
        auction.higestBid = msg.value;

        emit BidPlaced(_tokenId, msg.sender, msg.value);
    }

    // auction finalized
    function finalizeAuction(uint256 _tokenId) external {
        Auction storage auction = auctions[_tokenId];
        require(auction.active == true, "Auction not active");
        require(block.timestamp >= auction.endTime, "Auction not ended");

        auction.active = false;
        nftContract.safeTransferFrom(
            auction.seller,
            auction.highestBidder,
            _tokenId
        );
        auction.seller.transfer(auction.higestBid);

        emit AuctionFinalized(
            _tokenId,
            auction.highestBidder,
            auction.higestBid
        );
    }

    // auction cancelled
    function cancelAuction(uint256 _tokenId) external {
        Auction storage auction = auctions[_tokenId];
        require(auction.active == true, "Auction not active");
        require(nftContract.ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(block.timestamp < auction.endTime, "Auction ended");

        auction.active = false;
        if (auction.higestBid != 0) {
            payable(auction.highestBidder).transfer(auction.higestBid);
        }

        emit AuctionCancelled(_tokenId);
    }
}
