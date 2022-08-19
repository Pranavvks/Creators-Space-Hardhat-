require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

/** @type import('hardhat/config').HardhatUserConfig */



// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
// R6a3PZf4APtGhXfc2JJd5N


// const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || ""
// const RINKEBY_RPC_URL =
//     process.env.RINKEBY_RPC_URL || "https://eth-rinkeby.alchemyapi.io/v2/your-api-key"
// const PRIVATE_KEY = process.env.PRIVATE_KEY || ""
// const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || ""

require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

/** @type import('hardhat/config').HardhatUserConfig */

const PRIVATE_KEY = "a5725f181b6144096d66e7da83d2b52000d4b92f453b2747323bbf4b25b2051f"
const MATIC_RPC_URL = "https://rpc-mumbai.maticvigil.com/v1/2c67ca5c09dce14e3a751d1fa80fc8157996dc7a"


module.exports = {
  solidity: "0.8.7",
  networks: {
    mumbai: {
      url: MATIC_RPC_URL,
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      gasPrice: 10000000000,
      chainId: 80001
    },
  },
};

// module.exports = {

//  solidity:"0.8.7"
 


//     // defaultNetwork: "hardhat",
//     // networks: {
//     //     hardhat: {
//     //         chainId: 31337,
//     //         // gasPrice: 130000000000,
//     //     },
//     //     rinkeby: {
//     //         url: RINKEBY_RPC_URL,
//     //         accounts: [PRIVATE_KEY],
//     //         chainId: 4,
//     //         blockConfirmations: 6,
//     //     },
//     // },
//     // solidity: {
//     //     compilers: [
//     //         {
//     //             version: "0.8.8",
//     //         },
//     //         {
//     //             version: "0.6.6",
//     //         },
//     //     ],
//     // },
//     // etherscan: {
//     //     apiKey: ETHERSCAN_API_KEY,
//     // },
//     // gasReporter: {
//     //     enabled: true,
//     //     currency: "USD",
//     //     outputFile: "gas-report.txt",
//     //     noColors: true,
//     //     // coinmarketcap: COINMARKETCAP_API_KEY,
//     // },
//     // namedAccounts: {
//     //     deployer: {
//     //         default: 0, // here this will by default take the first account as deployer
//     //         1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
//     //     },
//     // },
//     // mocha: {
//     //     timeout: 200000, // 200 seconds max for running tests
//     // },
// }