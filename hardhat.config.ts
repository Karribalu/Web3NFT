import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    mumbai: {
      url: process.env.POLYGON_MUMBAI_RPC_URL ? process.env.POLYGON_MUMBAI_RPC_URL : "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 80001,
    },
    sepolia:
    {
      url: process.env.POLYGON_SEPOLIA_RPC_URL ? process.env.POLYGON_SEPOLIA_RPC_URL : "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 11155111,
    },
  },
  etherscan: {
    apiKey: process.env.POLYGON_SCAN_API_KEY ? process.env.POLYGON_SCAN_API_KEY : "",
  },
};

export default config;
