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
    bytes32 public proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 public proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne , proofTwo];

    uint256 public constant CLAIM_AMOUNT = 25 * 1e18;
    uint256 public AIRDROP_AMOUNT = CLAIM_AMOUNT * 4;
    address tommy;
    uint256 tommyPrivKey;


    function setUp() public {
        deployer = new DeployMerkleAirdrop();
        (lockInToken, merkleAirdrop) = deployer.run(ROOT_HASH);
        lockInToken.mint(lockInToken.owner(), AIRDROP_AMOUNT);
        lockInToken.transfer(address(merkleAirdrop), AIRDROP_AMOUNT);
        (tommy, tommyPrivKey) = makeAddrAndKey("tommy");
    }

    function testUserCanClaim() public {
        uint256 startingBalance = lockInToken.balanceOf(tommy);

        vm.prank(tommy);
        merkleAirdrop.claim(tommy, CLAIM_AMOUNT, PROOF);
        uint256 claimedBalance = lockInToken.balanceOf(tommy);
        assertEq(claimedBalance - startingBalance, CLAIM_AMOUNT);
    }
}