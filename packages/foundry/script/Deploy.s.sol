//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AssetToken} from "../contracts/AssetToken.sol";
import {CreditToken} from "../contracts/CreditToken.sol";
import {BasicDex} from "../contracts/BasicDex.sol";

import {ScaffoldETHDeploy, console2} from "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }

        address owner = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // deploy tokens
        CreditToken cred = new CreditToken("Salt", "SALT", owner);
        AssetToken avocado = new AssetToken("Avocado", "AVOC", owner);
        AssetToken banana = new AssetToken("Banana", "BNNA", owner);
        AssetToken tomato = new AssetToken("Tomato", "TMTO", owner);

        deployments.push(Deployment("creditToken", address(cred)));
        deployments.push(Deployment("avocadoToken", address(avocado)));
        deployments.push(Deployment("bananaToken", address(banana)));
        deployments.push(Deployment("tomatoToken", address(tomato)));

        console2.log("Salt Address", address(cred));
        console2.log("avocado Address", address(avocado));
        console2.log("banana Address", address(banana));
        console2.log("tomato Address", address(tomato));

        // deploy dexes
        BasicDex avocadoCred = new BasicDex(address(cred), address(avocado));
        console2.log("avocado Dex Address", address(avocadoCred));
        BasicDex bananaCred = new BasicDex(address(cred), address(banana));
        console2.log("banana Dex Address", address(bananaCred));
        BasicDex tomatoCred = new BasicDex(address(cred), address(tomato));
        console2.log("tomato Dex Address", address(tomatoCred));

        deployments.push(Deployment("avocadoDex", address(avocadoCred)));
        deployments.push(Deployment("bananaDex", address(bananaCred)));
        deployments.push(Deployment("tomatoDex", address(tomatoCred)));


        // approve dexes for trading
        cred.approve(address(avocadoCred), type(uint256).max);
        cred.approve(address(bananaCred), type(uint256).max);
        cred.approve(address(tomatoCred), type(uint256).max);
        avocado.approve(address(avocadoCred), type(uint256).max);
        banana.approve(address(bananaCred), type(uint256).max);
        tomato.approve(address(tomatoCred), type(uint256).max);

        // Add initial liquidity to dexes;
        avocadoCred.init(200 ether);
        bananaCred.init(200 ether);
        tomatoCred.init(200 ether);

        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}
