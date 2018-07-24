pragma solidity ^0.4.2;

import "./DappToken.sol";

contract DappTokenSale {

	address admin;
	DappToken public tokenContract;
	uint256 public tokenPrice;
	uint256 public tokensSold;

	event Sell(address _buyer, uint256 _amount);
	
	function DappTokenSale(DappToken _tokenContract, uint256 _tokenPrice) public {
		admin = msg.sender; //Assign an admin
		tokenContract = _tokenContract; //Token Contract
		tokenPrice = _tokenPrice;  //Set the token price
		
	}

	//multiply
	function multiply(uint x, uint y) internal pure returns (uint z){
		require(y == 0 || (z = x * y )/ y == x);
	}
	//Buy Tokens

	function buyTokens(uint256 _numberOfTokens) public payable{

		// Require that value is equal to tokens
		require(msg.value == multiply(_numberOfTokens, tokenPrice));
		// Require that contract has enough tokens
		// Require that a transfer is successful
		require(tokenContract.balanceOf(this) >= _numberOfTokens);
		require(tokenContract.transfer(msg.sender, _numberOfTokens));
		
		tokensSold += _numberOfTokens; // Keep track of no of tokens currently sold

		Sell(msg.sender, _numberOfTokens); // Trigger sell event
		
	}
	//End token sale
	function endSale() public {
		//Require admin
		require(msg.sender == admin);

		//Remaining Dapp tokens to admin
		require(tokenContract.transfer(admin, tokenContract.balanceOf(this))); 
		//Destroy Contract
		selfdestruct(admin);
	}
}