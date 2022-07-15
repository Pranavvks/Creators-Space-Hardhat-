// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// We are inheriting ERC721URIStorage instead of ERC721
// This will allow us to use the _setTokenURI() function
contract NFT is ERC721URIStorage {
   using Counters for Counters.Counter;
   Counters.Counter private _tokenIds;

   address public artist;
   address public txFeeToken;
   uint256 public txFeeAmount;
   mapping(address => bool) public excludedList;

   constructor(
    address _artist, 
    address _txFeeToken,
    uint _txFeeAmount
  ) ERC721('RandomAritst', 'ABC') {
    artist = _artist;
    txFeeToken = _txFeeToken;
    txFeeAmount = _txFeeAmount;
    excludedList[_artist] = true;
  }

   function setExcluded(address excluded, bool status) external {
    require(msg.sender == artist, 'artist only');
    excludedList[excluded] = status;
  }

   function mintNFT(address recipient, string memory tokenURI)
       public
       returns (uint256)
   {
       _tokenIds.increment();
       uint256 newItemId = _tokenIds.current();
       _safeMint(recipient, newItemId);
       _setTokenURI(newItemId, tokenURI);
       return newItemId;
   }

   // To implement royalties, we need to override the methods in ERC721URIStorage
   // The methods include transferFrom(from, to tokenID), safeTansferFrom(from, to tokenID), safeTansferFrom(from, to, tokenID, data)
   function transferFrom(
    address from, 
    address to, 
    uint256 tokenId
  ) public override {
     require(
       _isApprovedOrOwner(_msgSender(), tokenId), 
       'ERC721: transfer caller is not owner nor approved'
     );
     if(excludedList[from] == false) {
      _payTxFee(from);
     }
     _transfer(from, to, tokenId);
  }

   function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
   ) public override {
     require(
      _isApprovedOrOwner(_msgSender(), tokenId), 
      'ERC721: transfer caller is not owner nor approved'
    );
     if(excludedList[from] == false) {
       _payTxFee(from);
     }
     safeTransferFrom(from, to, tokenId, '');
   }

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) public override {
    require(
      _isApprovedOrOwner(_msgSender(), tokenId), 
      'ERC721: transfer caller is not owner nor approved'
    );
    if(excludedList[from] == false) {
      _payTxFee(from);
    }
    _safeTransfer(from, to, tokenId, _data);
  }

   function _payTxFee(address from) internal {
    IERC20 token = IERC20(txFeeToken);
    token.transferFrom(from, artist, txFeeAmount);
  }
}
