const ethers = require('ethers') 
const SIGNING_DOMAIN_NAME = "LazyNFT-Voucher"
const SIGNING_DOMAIN_VERSION = "1" 









class LazyMinter {
    constructor({contract , signer})
    {
        this.contract = contract 
        this.signer = signer
    }
    async createVoucher(tokenId, uri, minPrice = 0) {
        const voucher = { tokenId, uri, minPrice }
        const domain = await this._signingDomain()
        const types = {
          NFTVoucher: [
            {name: "tokenId", type: "uint256"},
            {name: "minPrice", type: "uint256"},
            {name: "uri", type: "string"},  
          ]
        }
        const signature = await this.signer._signTypedData(domain, types, voucher)
        return {
          ...voucher,
          signature,
        }
      }
      async _signingDomain() {
        if (this._domain != null) {
          return this._domain
        }
        const chainId = await this.contract.getChainID()
        this._domain = {
          name: SIGNING_DOMAIN_NAME,
          version: SIGNING_DOMAIN_VERSION,
          verifyingContract: this.contract.address,
          chainId,
        }
        return this._domain
      }

}





/***
 *  We have a LazyMinter class objects of this class 
 *  const  
 *  const url = "https://eth-rinkeby.alchemyapi.io/v2/n9Zj9j6J-jnvVWXpZoxUvRbElcz5Ih8P"
    const provider = new ethers.providers.JsonRpcProvider(url);
    const signer = new ethers.Wallet("a5725f181b6144096d66e7da83d2b52000d4b92f453b2747323bbf4b25b2051f", provider);
    const contract = new ethers.Contract()
    const example = new ethers.Contract(CONTRACT_ADDRESS, contractABI, signer);

 *  let lazymintedtokenone = new LazyMinter()
 * // LazyMinter contract requires the contract 
 * // Now for interacting with our contract we need a signer
 * // This is where JSONRPC node providers like alchemy comes into 
 *  // picture
 *   WHAT IS JSON-RPC ? 
 *   Remote procedure call protocol encoded in JSON 
 *   Node is a program runnig on a computer which helps
 *   connect with the rest of the blockchain network.
 */


module.exports = {
    LazyMinter
  }