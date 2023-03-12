let dotenv = require('dotenv');
dotenv.config({path:"./.env"});
const mnemonic = process.env.MNEMONIC;
const scankey = process.env.ETHERSCAN_API_KEY;
const privatekey = process.env.PRIVATE_KEY;

const { ethers } = require("hardhat");
const hre = require("hardhat");


const main = async () => {

    //合约地址
    let contractAddress = "0x8FdB9703afff36335b1e8665b937279F674b44ba"; 
    //ABI合约接口定义
    let contractABI =  [{"inputs":[{"internalType":"uint256","name":"x","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"count","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"counter","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}];

    //Provider
    const quicknodeUrl = "https://endpoints.omniatech.io/v1/matic/mumbai/public";
    const provider = await new hre.ethers.getDefaultProvider(quicknodeUrl);  //连接网络
    console.log(provider);

    //只读操作
    //let balance = await provider.count();
  
    //Signer签名
    console.log("获取provider");
    const signer =  await new hre.ethers.Wallet(privatekey, provider);
    let signerAddress = await signer.getAddress();
    console.log("signer address", signerAddress);
    console.log("获取signer");
    //合约对象
    const countContract = await new ethers.Contract(contractAddress, contractABI, provider);
    console.log("获取countContract");
    const countContracts = await countContract.connect(signer); //合约的写方法，需要Signer
    console.log("countContract.connect(signer)");
    //调用合约方法
    let txn = await countContracts.count();
    console.log("success");
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();
