// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AssetToken} from "../contracts/AssetToken.sol";
import {CreditToken} from "../contracts/CreditToken.sol";
import "forge-std/StdJson.sol";

import {ScaffoldETHDeploy, VmSafe, console2} from "./DeployHelpers.s.sol";


struct ContractAddresses {
    address avocadoDex;
    address avocadoToken;
    address bananaDex;
    address bananaToken;
    address creditToken;
    address tomatoDex;
    address tomatoToken;
}

contract PrepBurnerTraders is ScaffoldETHDeploy {
    using stdJson for string;


    /// create private keys
    /// store private keys to env
    /// send gas token/credit/asset to address
    /// max approve dex asset/credit

    function run() external {
        string memory writePath = ".env";
        uint256 deployerPk = setupLocalhostEnv();
        address deployerAddress = vm.addr(deployerPk);
        console2.log("deployer address", deployerAddress);
    

        VmSafe.Wallet memory avocado = vm.createWallet("avocado113311ss");
        VmSafe.Wallet memory banana = vm.createWallet("banana1092201bb");
        VmSafe.Wallet memory tomato = vm.createWallet("tomato120104291ff");
        vm.writeLine(
            writePath,
            string(
                abi.encodePacked(
                    "AVOCADO_PK=",
                    vm.toString(avocado.privateKey)
                )
            )
        );
        vm.writeLine(
            writePath,
            string(
                abi.encodePacked(
                    "BANANA_PK=",
                    vm.toString(banana.privateKey)
                )
            )
        );
        vm.writeLine(
            writePath,
            string(
                abi.encodePacked(
                    "TOMATO_PK=",
                    vm.toString(tomato.privateKey)
                )
            )
        );
        string memory projectRoot = vm.projectRoot();
        
        // change path to match chainId of target chain
        string memory jsonPath = string.concat(projectRoot,"/deployments/100.json");
        string memory jsonOutput = vm.readFile(jsonPath);
        bytes memory contractDetails = jsonOutput.parseRaw("");
        ContractAddresses memory contractAddrs = abi.decode(contractDetails, (ContractAddresses));
        console2.log("Credit addr", contractAddrs.creditToken);
        console2.log("Avocado addr", contractAddrs.avocadoToken);
        console2.log("Banana addr", contractAddrs.bananaToken);
        console2.log("Tomato addr", contractAddrs.tomatoToken);
        console2.log("Avocado dex", contractAddrs.avocadoDex);
        console2.log("banana dex", contractAddrs.bananaDex);
        console2.log("tomato dex", contractAddrs.tomatoDex);
        vm.startBroadcast(deployerPk);

        // console2.log(
        //     "Deployed credit balance",
        //     IERC20(contractAddrs.creditToken).balanceOf(deployerAddress)
        // );

        
        // send gas to wallets
        payable(avocado.addr).transfer(0.01 ether);
        payable(banana.addr).transfer(0.01 ether);
        payable(tomato.addr).transfer(0.01 ether);

        // console2.log("Avocado Trader Balance", avocado.addr.balance);
        // console2.log("Banana Trader Balance", banana.addr.balance);
        // console2.log("Tomato Trader Balance", tomato.addr.balance);

        // send credit to wallets
        CreditToken(contractAddrs.creditToken).transfer(avocado.addr, 200 ether);
        CreditToken(contractAddrs.creditToken).transfer(banana.addr, 200 ether);
        CreditToken(contractAddrs.creditToken).transfer(tomato.addr, 200 ether);

        console2.log("Avocado Trader Credit Balance", CreditToken(contractAddrs.creditToken).balanceOf(avocado.addr));
        console2.log("Banana Trader Credit Balance", CreditToken(contractAddrs.creditToken).balanceOf(banana.addr));
        console2.log("Tomato Trader Credit Balance", CreditToken(contractAddrs.creditToken).balanceOf(tomato.addr));

        // send token to each
        AssetToken(contractAddrs.avocadoToken).transfer(avocado.addr, 200 ether);
        AssetToken(contractAddrs.bananaToken).transfer(banana.addr, 200 ether);
        AssetToken(contractAddrs.tomatoToken).transfer(tomato.addr, 200 ether);
    }
}
