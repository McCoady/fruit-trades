// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./solmate/ERC20.sol";
import "./solmate/Owned.sol";

contract AssetToken is ERC20, Owned{
    constructor(string memory _name, string memory _symbol, address _owner) ERC20(_name, _symbol, 18) Owned(_owner) {
        _mint(msg.sender, 1000 ether);
    }

    function airdropToWallet(address _wallet) external onlyOwner {
        _mint(_wallet, 100 ether);
    }

    function airdropToWallets(address[] calldata _wallets) external onlyOwner {
        uint256 walletsNo = _wallets.length;

        for(uint i; i < walletsNo; ++i) {
            _mint(_wallets[i], 100 ether);
        }
    }
}
