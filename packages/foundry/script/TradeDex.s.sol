// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {BasicDex} from "../contracts/BasicDex.sol";
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

contract TradeDexScript is ScaffoldETHDeploy {
    using stdJson for string;

    function run() external {
        uint256 avocadoPk = vm.envUint("AVOCADO_PK");

        string memory projectRoot = vm.projectRoot();
        string memory jsonPath = string.concat(projectRoot,"/deployments/100.json");
        string memory jsonOutput = vm.readFile(jsonPath);
        bytes memory contractDetails = jsonOutput.parseRaw("");
        ContractAddresses memory contractAddrs = abi.decode(contractDetails, (ContractAddresses));
 

        // vm.startBroadcast(avocadoPk);

        // AssetToken(contractAddrs.avocadoToken).approve(contractAddrs.avocadoDex, type(uint256).max);
        // CreditToken(contractAddrs.creditToken).approve(contractAddrs.avocadoDex, type(uint256).max);
        // vm.stopBroadcast();

        while (true) {
            if (block.number % 2 == 0) {
                // trade
                vm.startBroadcast(avocadoPk);
                BasicDex(contractAddrs.avocadoDex).assetToCredit(0.1 ether, 0);
                vm.stopBroadcast();
            }
        }
    }
}