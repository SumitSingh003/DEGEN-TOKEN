// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable{

    struct Item{
        string name;
        uint price;
    }

    Item[] private _storeItems;

    constructor() ERC20("Degen", "DGN") {
        _storeItems.push(Item("Armor", 100));
        _storeItems.push(Item("Potion", 200));
        _storeItems.push(Item("Sword", 300));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burnTokens(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferTokens(address _receiver, uint256 _amount) external {
        require(balanceOf(msg.sender) >= _amount, "You do not have enough Degen Tokens");
        approve(msg.sender, _amount);
        transferFrom(msg.sender, _receiver, _amount);
    }

    function show_Items() external view returns (string memory) {
        string memory response = "Items: ";

        for (uint i = 0; i < _storeItems.length; i++) {
            response = string.concat(response, "\n", Strings.toString(i+1), ". ", _storeItems[i].name);
        }

        return response;
    }

    function redeemItem(uint8 itemNumber) external payable returns (string memory) {
        require(itemNumber > 0 && itemNumber <= _storeItems.length, "Invalid choice");
        Item memory item = _storeItems[itemNumber-1];
        require(this.balanceOf(msg.sender) >= item.price, "You do not have enough Degen Tokens");
        approve(msg.sender, item.price);
        transferFrom(msg.sender, owner(), item.price);
        return string.concat("Successfully redeemed ", item.name);
    }

}