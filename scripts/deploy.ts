import { ethers } from "hardhat";
import hre from "hardhat";
import "dotenv/config";

async function main() {
    const[deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    const balance = await deployer.getBalance();
    console.log("Account balance:", balance.toString());
    const Web3NFTContract = await ethers.getContractFactory("Web3NFTContract");
    const payees = [process.env.PUBLIC_KEY_1 ? process.env.PUBLIC_KEY_1 : "" , process.env.PUBLIC_KEY_2 ? process.env.PUBLIC_KEY_2 : ""]
    const shares = [ "80","20"]
    const web3NFTContract = await Web3NFTContract.deploy( payees, shares);
    await web3NFTContract.deployed();
    console.log("Contract address:", web3NFTContract.address);
    await web3NFTContract.deployTransaction.wait(5);
    //verifying the contract
    verify(web3NFTContract.address, [payees, shares]);
}
async function verify(contractAddress : string, args: any[]) {
  try {
      await hre.run("verify:verify", {
          address: contractAddress,
          constructorArguments: args,
      })
  } catch (e) {
      console.log(e)
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
