// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {BukuTamu} from "../src/BukuTamu.sol";

contract BukuTamuTest is Test {
    BukuTamu public bukuTamu;
    address public user = address(0x123);

    event CatatanBaru(address indexed pengirim, string pesan, uint256 waktu);

    function setUp() public {
        bukuTamu = new BukuTamu(60);
    }

    function testIsiBukuTamu() public {
        vm.startPrank(user);
        
        vm.expectEmit(true, false, false, true);
        emit CatatanBaru(user, "Halo, sukses terus hackathon-nya!", block.timestamp);
        
        bukuTamu.isiBukuTamu("Halo, sukses terus hackathon-nya!");
        vm.stopPrank();
    }

    function testSetJedaWaktuOnlyPanitia() public {
        vm.prank(user);
        vm.expectRevert("BukuTamu: Hanya panitia yang bisa mengubah jeda waktu");
        bukuTamu.setJedaWaktu(120);
    }
}
