//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;
pragma abicoder v2; // required to accept structs as function parameters
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol"; 
import "../contracts/NFTCollectionOwner.sol" ;

contract NFT is ERC721URIStorage, EIP712, AccessControl , ERC2981 {
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  string private constant SIGNING_DOMAIN = "LazyNFT-Voucher";
  string private constant SIGNATURE_VERSION = "1";
  // address payable  RoyaltyAddress ;
  address _NFTCollectionOwnerContractAddress=0x92544951e7142f38Ba288E5Dab2a9b7339e2e794 ;
  // fake address
  event Sale(address indexed from, address indexed to, uint256 indexed value);
  event Mint(address indexed caller , uint256 indexed tokenId);

  constructor(address payable minter)
  
  ERC721("NFT", "LAZ") 
    EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {
      _setupRole(MINTER_ROLE, minter);
    }
  

    


  

  mapping (address => uint256) pendingWithdrawals;
  
  
  /// @notice Represents an un-minted NFT, which has not yet been recorded into the blockchain. A signed voucher can be redeemed for a real NFT using the redeem function.
  struct NFTVoucher {
    /// @notice The id of the token to be redeemed. Must be unique - if another token with this ID already exists, the redeem function will revert.
    uint256 tokenId;

    /// @notice The minimum price (in wei) that the NFT creator is willing to accept for the initial sale of this NFT.
    uint256 minPrice;

    /// @notice The metadata URI to associate with this token.
    string uri;

    /// @notice the EIP-712 signature of all other fields in the NFTVoucher struct. For a voucher to be valid, it must be signed by an account with the MINTER_ROLE.
    bytes signature;
  }

  /** @dev For implementing the EIP:712 standard , 
  which helps for doing meta transactions : Here in our 
  NFT marketplace for the creators to list their NFT art within 
  the marketplace without them having to pay the gas fees for minting 
  the NFT collection gas fees are paid by the fans with the amount for 
  eth transfer.

  1. Design the DS (Here in our case the data structure for NFTVoucher)
  2. Design domain sepearator 
      -It helps to prevent signature meant for one dApp from working in 
      another

  Royalty Setting :
  1. We need a way to figure out whether a safetransfer from one contract
  address to another is a sale or it is a simple transfer event

  We don't want to hardcode our NFT collection creator's address. 
  Solution : Proxy contract


   */



   function GetRoyaltyAddress(  ) public payable returns (address) 
   {
     
     NFTCollectionOwner(_NFTCollectionOwnerContractAddress).getRoyaltyAddress();
     
      
   } // If the royalty address changes 

  function getRoyaltyFee( uint256 tokenId ,uint256 moneySent  ) public view  returns (uint256 _amount, address payable _RoyaltyAddress )
  {
      
        NFTCollectionOwner(_NFTCollectionOwnerContractAddress).RoyaltyPrice(tokenId,moneySent);
  }

  function PayRoyalty(uint256 _royaltyFees , address  artistAddress) internal 
  {
    (bool success , ) = payable(artistAddress).call{value : _royaltyFees}("");
     require(success);
  }
   

  //  (400 / 1000)/10000
  //  4/10/10000
  // 


  /// @notice Redeems an NFTVoucher for an actual NFT, creating it in the process.
  /// @param redeemer The address of the account which will receive the NFT upon success.
  /// @param voucher A signed NFTVoucher that describes the NFT to be redeemed.
  function redeem(address redeemer, NFTVoucher calldata voucher) public payable  {
    // make sure signature is valid and get the address of the signer
    address signer = _verify(voucher);



    // make sure that the signer is authorized to mint NFTs
    require(hasRole(MINTER_ROLE, signer), "Signature invalid or unauthorized");

    // make sure that the redeemer is paying enough to cover the buyer's cost



    require(msg.value >= voucher.minPrice, "Insufficient funds to redeem");
    
   
    // Note reedemer address is a dummy address we will replace it with contract address during testing.
    // 

    // GetRoyaltyAddress();
    
    // first assign the token to the signer, to establish provenance on-chain

    // (uint256 amt , address RoyaltyAddr) = getRoyaltyFee(voucher.tokenId , msg.value);

    //  PayRoyalty(amt, RoyaltyAddr);

    

     address Owner ;

     ( Owner ) =  GetRoyaltyAddress();

     (bool success , ) = payable(Owner).call{
      value : msg.value 
     }("");

      require(success);

     _safeMint(msg.sender, voucher.tokenId);

     emit Mint(msg.sender, voucher.tokenId);
      
      // The royalty amount will be 10% of the NFT price. During testing 
      
    //  _setTokenURI(voucher.tokenId, voucher.uri);
    
    // transfer the token to the redeemer
    // _transfer(signer, redeemer, voucher.tokenId);

    // record payment to signer's withdrawal balance
    // pendingWithdrawals[signer] += msg.value;
    // Keeps track of the total amount transferred by a particular
    // person for purchasing NFT's

    // return voucher.tokenId;
  }

  
    function TransferNFTFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable  {
    require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

    if(msg.value > 0)
    {
      uint256 amt ; address RoyaltyAddr ;
     ( amt ,  RoyaltyAddr) = getRoyaltyFee(tokenId , msg.value);
      PayRoyalty(amt, RoyaltyAddr);
      (bool success , ) = payable(from).call{value : msg.value - amt}("");
      require(success);
      emit Sale(from , to , msg.value);
      _transfer(from, to, tokenId);
    }

  }
  



    



  /// @notice Transfers all pending withdrawal balance to the caller. Reverts if the caller is not an authorized minter.
  function withdraw() public {
    require(hasRole(MINTER_ROLE, msg.sender), "Only authorized minters can withdraw");
    
    // IMPORTANT: casting msg.sender to a payable address is only safe if ALL members of the minter role are payable addresses.
    address payable receiver = payable(msg.sender);

    uint amount = pendingWithdrawals[receiver];
    // zero account before transfer to prevent re-entrancy attack
    pendingWithdrawals[receiver] = 0;
    receiver.transfer(amount);
  }

  /// @notice Retuns the amount of Ether available to the caller to withdraw.
  function availableToWithdraw() public view returns (uint256) {
    return pendingWithdrawals[msg.sender];
  }

  /// @notice Returns a hash of the given NFTVoucher, prepared using EIP712 typed data hashing rules.
  /// @param voucher An NFTVoucher to hash.
  function _hash(NFTVoucher calldata voucher) internal view returns (bytes32) {
    return _hashTypedDataV4(keccak256(abi.encode(
      keccak256("NFTVoucher(uint256 tokenId,uint256 minPrice,string uri)"),
      voucher.tokenId,
      voucher.minPrice,
      keccak256(bytes(voucher.uri))
    )));
  }

  /// @notice Returns the chain id of the current blockchain.
  /// @dev This is used to workaround an issue with ganache returning different values from the on-chain chainid() function and
  ///  the eth_chainId RPC method. See https://github.com/protocol/nft-website/issues/121 for context.
  function getChainID() external view returns (uint256) {
    uint256 id;
    assembly {
        id := chainid()
    }
    return id;
  }

  /// @notice Verifies the signature for a given NFTVoucher, returning the address of the signer.
  /// @dev Will revert if the signature is invalid. Does not verify that the signer is authorized to mint NFTs.
  /// @param voucher An NFTVoucher describing an unminted NFT.
  function _verify(NFTVoucher calldata voucher) internal view returns (address) {
    bytes32 digest = _hash(voucher);
    return ECDSA.recover(digest, voucher.signature);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override (AccessControl, ERC721 , ERC2981 ) returns (bool) {
    return ERC721.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId);
  }
}


// function airdrop (mapping(address=>bool) _recipients , uint[] _values)  onlyOwner public returns (bool)
// {
//   require(msg.sender == );
//   for(uint i=0 ; i<_values.length ; i++)
//   {
   
//   }
// }
/**
There needs to be a way to implement the functionality of
transffering the royalty amount from the buyer of the NFT to the 
NFTCollectionOwner
 */