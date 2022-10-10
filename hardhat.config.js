require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");

const RPC_URL = process.env.MUMBAI_RPC_URL;
const PK = process.env.PK;
const API_KEY = process.env.API_KEY;

module.exports = {
  solidity: "0.8.1",
  networks: {
    mumbai: {
      url: RPC_URL,
      accounts: [PK],
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: API_KEY,
    },
  },
};
