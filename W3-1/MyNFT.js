// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
// const hre = require("hardhat");
const { ethers, network, artifacts } = require("hardhat");

let dotenv = require('dotenv');
dotenv.config({path:"./.env"});
const walletAddress = process.env.WALLET_ACCOUNT;

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const unlockTime = currentTimestampInSeconds + 60;
  // const unlockTime = currentTimestampInSeconds + 60;

  // const lockedAmount = hre.ethers.utils.parseEther("0.001");

  // const Lock = await hre.ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });



  const MyNFT721 = await ethers.getContractFactory("MyNFT721");
  const myNFT721 = await MyNFT721.deploy();
  await myNFT721.deployed();
//   myNFT721.mint(walletAddress,"ipfs://QmZFvFs1MpgXrErgGVw58k9qFCeawggbcqrCHjVW7xkB4q")
  console.log("myNFT721 deployed to:", myNFT721.address);


  // console.log(
  //   `Lock with ${ethers.utils.formatEther(
  //     lockedAmount
  //   )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
  // );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
