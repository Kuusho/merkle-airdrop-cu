//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {LockInToken} from "../src/LockInToken.sol";
import {DeployMerkleAirdrop} from "../script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is Test{
    MerkleAirdrop public merkleAirdrop;
    LockInToken public lockInToken;
    DeployMerkleAirdrop public deployer;

    bytes32 public constant ROOT_HASH = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    address tommy;
    uint256 tommyPrivKey;


    function setUp() public {
        deployer = new DeployMerkleAirdrop();
        (lockInToken, merkleAirdrop) = deployer.run(ROOT_HASH);
        (tommy, tommyPrivKey) = makeAddrAndKey("tommy");
    }

    function testUserCanClaim() public view {
    }
}