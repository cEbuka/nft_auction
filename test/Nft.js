const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Deployment", function () {
    async function deployNftFixture() {

        // get contract
        const NftContract = await ethers.getContractFactory("NFT");
        // get signers
        const [owner, addr1] = await ethers.getSigners();

        // deploy contract
        const Nft = await NftContract.deploy("Baby Sharks", "BSS");
        //return these
        return { Nft, owner, tokenId, addr1 }
    }

    describe("mint", function () {
        it("should revert if max supply is exceeded", async function () {
            const { Nft } = await loadFixture(deployNftFixture);

            const max = 10;

            await expect(await Nft.safemint(max, "sgsgg").to.be.revertedWith("Max supply reached"))
        })
    })
})

