const { ethers } = require('hardhat');

async function main() {

  const nft = await ethers.deployContract('NFT');
  await nft.waitForDeployment();

  const nftAuction = await ethers.deployContract('NFTAuction', await [nft.target]);
  await nftAuction.waitForDeployment();

  console.log('NFT Contract Deployed at ' + nft.target);
  console.log("NftAuction deployed at" + nftAuction.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
