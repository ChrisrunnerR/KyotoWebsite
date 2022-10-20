//"SPDX-License-Identifier: UNLICENSED"

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';


contract KyotoNFT is ERC721 , Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint public maxPerWallet;

    // determinies when users can mint 
    bool public isPublicMintEnabled;

    // allows if you're using opensea to get url of where images are located 
    string internal baseTokenUri;
    
    // how you would withdraw the money from the contract
    address payable public withdrawWallet;

    // keeps track of all mints  that way no one can mint twice
    mapping(address =>uint256) public walletMints;

// runs at contract creation
    constructor() payable ERC721('KyotoNFT', 'KY'){
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply= 1000;
        maxPerWallet = 2;          
        //set  
        //withdrawWaller =; 

    }


// allows onlyOwner to call this function / person who deploys contract 
function setIsPublicMintEnabled(bool _isPublicMintEnabled) external onlyOwner{
    isPublicMintEnabled = _isPublicMintEnabled;
}
// url of where images are located 
    function setBaseTokenUri( string calldata _baseTokenUri) external onlyOwner{
        baseTokenUri = _baseTokenUri;
 }
// function exists in ERC721 function opensea will be what image is displayed for each token
 function tokenURI(uint256 _tokenId) public view override returns (string memory){
     require(_exists(_tokenId), 'Token does not exist!');
/* we are taking the url that we identified, grabbing the ID and placing it after the url
 then adding on .json || it calls tokenURI for each image || */
  return string(abi.encodePacked(baseTokenUri, Strings.toString(_tokenId), ".json" ));
}

// allows us to withdraw the funds to the address we specified with withdrawWallet
function withdraw() external onlyOwner{
    (bool success, ) = withdrawWallet.call{value: address(this).balance}('');
    require(success, 'Withdraw failed!');
}

function mint(uint256 _quantity) public payable{
    require(isPublicMintEnabled, 'minting not enabled');
    // make sure user is inputting correct value 
    require(msg.value == _quantity * mintPrice, 'wrong mint value');
    require(totalSupply + _quantity <= maxSupply, 'sold out');

// make sure user doesn't have over set limit of tokens
    require(walletMints[msg.sender] + _quantity <= maxPerWallet, 'max per wallet reached');

    for(uint256 i = 0; i < _quantity ; i++){
        uint256 newTokenId = totalSupply + 1;
        totalSupply++;
        _safeMint(msg.sender, newTokenId);
    
    }
}

}

//import  '@openzeppelin/contracts/token/ERC721/ERC721.sol;
