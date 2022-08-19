async function deployContract() {
    const NFT = await ethers.getContractFactory("NFT")
    const exampleNFT = await NFT.deploy("0x92544951e7142f38Ba288E5Dab2a9b7339e2e794")
    // owner 
    // ethereum
    // 

    await exampleNFT.deployed()
    const txHash = exampleNFT.deployTransaction.hash
    const txReceipt = await ethers.provider.waitForTransaction(txHash)
    const contractAddress = txReceipt.contractAddress
    console.log("Contract deployed to address:", contractAddress)
   }
   
  deployContract()
  .then(() => process.exit(0))
  .catch((error) => {
   console.error(error);
   process.exit(1);
  });