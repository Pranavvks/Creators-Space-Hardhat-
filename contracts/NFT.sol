// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol"; 
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract NFT is ERC2981 , Ownaable , ERC721Enumerable , ReentrancyGuard {

mapping(address=>bool) private WhiteListedAddresses;
mapping(address=>uint) public OwnershipTracker;

uint256 public constant c_COLLECTION_SIZE = 5263 ;
uint256 public constant c_TOKENS_PER_PERSON = 5 ;


using Counters for Counters.Counter ;


uint256 EntryTokens = 4000 ;
uint256 HangoutToken = 300 ;
uint256 Facetimetoken = 200 ;
uint256 Breakfasttoken = 50 ;
uint256 BrunchToken = 50 ;
uint256 DinnerToken = 50 ;
uint256 ShoppingToken = 30 ; //4680
uint256 WorkoutToken = 5 ;   // 4685
uint256 BowlingToken = 10 ;  // 4705
uint256 AllConcertAccess = 200 ; // 4905
uint256 VIPConcert = 20 ; // 4925
uint256 Breakfasttoken = 50 ; // 4975
uint256 BrunchToken = 50 ;  // 5025
uint256 VirtualMentorship = 15 ; // 5040 
uint256 Mentorship = 5 ; // 5045
uint256 GroupMentoring = 20 ; // 5065
uint256 CollabTokens = 3 ; // 5068
uint256 ConcertMix = 10 ; // 5078
uint256 RequestYourArtistFav = 10 ; // 5088
uint256 FirstAcceesTokens_MP3 = 100 ; // 5188
uint256 FirstAcceesTokens_MP4 = 75 ; // 5263

// 5188 

// TO DO :
    // 1. Set up the functions for
        // a. mint token 
        // b. transfer token
        // c. royalty
        // d.  
        // e. 
        // f. 
    // 2. Modifiers required
    // 3. Usage of IPFS and filecoin to upload metadata 
    // 4. Find out whether we need to create a struct
    //    or the same can be adapted to   



struct NftAttributes 
    {
        uint256 tokenId ;
        uint256 tokenName ;
        string ImageURI ;
        string tokenURI  ;
    };

mapping(address=>NftAttributes) public BasicAttributeTracker ;


/**Every time we create an instance of the NFT contract
to mint a NFT , using the constructor we can set up the 
inital attributes.

Further we will create a seperate function which will
then decide what type of NFT we are minting based 

*/

/**
         struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;        
    uint hp;
    uint maxHp;z
    uint attackDamage;
  }
 */


// Every NFT will have a set of commonattributes
// 



struct AccessTokenNFT
{
    CommonAttributes  attr memory[] ;
}

    


}
