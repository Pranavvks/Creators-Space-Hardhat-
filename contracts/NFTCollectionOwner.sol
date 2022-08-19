//SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol"; 

contract NFTCollectionOwner is Ownable ,  ERC2981
{

    // address payable RoyaltyReceiverAddress ;
    function getRoyaltyAddress()  public view   returns (address payable ) 
    {
    //   return  owner ();
    //  RoyaltyReceiverAddress = payable(owner());
     return (payable(owner()))   ;
    }

     function setDefaultRoyalty(uint96 feeNumerator) private onlyOwner
   {
    _setDefaultRoyalty(owner(), feeNumerator);
   }

//   function setTokenRoyalty(
//         uint256 tokenId,
//         uint96 feeNumerator
//     ) external onlyOwner {
//         _setTokenRoyalty(tokenId, owner(), feeNumerator);
//     }


    // function GetRoyaltyInfo(uint256 _saleprice) external returns (uint256)
    // {
    //     royaltyInfo(_tokenId, _salePrice);
    // }



 function RoyaltyPrice( uint256 tokenId,uint256 _salePrice) public view  returns (address ,uint256)
 {
   return royaltyInfo(tokenId,_salePrice);
 }
    
     function deleteDefaultRoyalty() external onlyOwner {
        _deleteDefaultRoyalty();
    }
}
