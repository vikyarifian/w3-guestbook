// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {BukuTamu} from "../src/BukuTamu.sol";

contract Deploy is Script {
    function run() external returns (address) {
        // Workaround for Foundry limitation: vm.envUint fails if the private key contains a '0x' prefix in certain OS shells, so we verify with vm.envOr first and parse
        uint256 deployerPrivateKey;
        string memory pkEnv = vm.envOr("PRIVATE_KEY", string(""));
        
        if (bytes(pkEnv).length == 0) {
            // Fallback to default local Anvil key for easy hackathon and local deployment setups
            deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        } else {
            deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerPrivateKey);

        // Default rate limit jeda_waktu of 60 seconds for visitor signatures
        BukuTamu bukuTamu = new BukuTamu(60);

        vm.stopBroadcast();

        return address(bukuTamu);
    }
}
