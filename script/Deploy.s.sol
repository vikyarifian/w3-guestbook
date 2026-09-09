// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {BukuTamu} from "../src/BukuTamu.sol";

contract Deploy is Script {
    function run() external returns (address) {
        // Workaround for Foundry limitation: vm.envUint fails if the private key contains a '0x' prefix in certain OS shells, so we verify with vm.envOr first and parse manually if needed
        uint256 deployerPrivateKey;
        string memory pkEnv = vm.envOr("PRIVATE_KEY", string(""));
        
        if (bytes(pkEnv).length == 0) {
            // Fallback to default local Anvil key for easy hackathon and local deployment setups
            deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        } else {
            // If it starts with 0x or 0X, parse manually to prevent vm.envUint from reverting on the prefix
            if (bytes(pkEnv).length > 2 && bytes(pkEnv)[0] == 0x30 && (bytes(pkEnv)[1] == 0x78 || bytes(pkEnv)[1] == 0x58)) {
                deployerPrivateKey = parseHex(pkEnv);
            } else {
                deployerPrivateKey = vm.envUint("PRIVATE_KEY");
            }
        }

        vm.startBroadcast(deployerPrivateKey);

        // Default rate limit jeda_waktu of 60 seconds for visitor signatures
        BukuTamu bukuTamu = new BukuTamu(60);

        vm.stopBroadcast();

        return address(bukuTamu);
    }

    function parseHex(string memory s) internal pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 result = 0;
        for (uint256 i = 2; i < b.length; i++) {
            uint256 val = uint256(uint8(b[i]));
            if (val >= 48 && val <= 57) {
                val = val - 48;
            } else if (val >= 97 && val <= 102) {
                val = val - 97 + 10;
            } else if (val >= 65 && val <= 70) {
                val = val - 65 + 10;
            } else {
                revert("Invalid hex character");
            }
            result = result * 16 + val;
        }
        return result;
    }
}
