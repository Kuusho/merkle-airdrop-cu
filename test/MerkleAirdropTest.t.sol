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

    bytes32 public constant ROOT_HASH = 0x7233ce664db632afc791a028febd2fd0fe5bd13bc8641464ff861895f971f4f5;
    bytes32 public proofOne = 0x2b51471ad936d66836d49428a3f4752c73d6647184315fee76e25263d39c3be6;
    bytes32 public proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public proof = [proofOne , proofTwo];

    uint256 public constant CLAIM_AMOUNT = 25 * 1e18;
    uint256 public AIRDROP_AMOUNT = CLAIM_AMOUNT * 4;
    address timo;
    uint256 timoPrivKey;
    address public grey;


    function setUp() public {
        deployer = new DeployMerkleAirdrop();
        (merkleAirdrop, lockInToken) = deployer.run();        
        (timo, timoPrivKey) = makeAddrAndKey("Timo");
        
    }

    function testTimoCanClaim() public {
        console.log(timo);
        uint256 startingBalance = lockInToken.balanceOf(timo);

        bytes32 digest = merkleAirdrop.getMessageHash(timo, CLAIM_AMOUNT);


        vm.prank(timo);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(timoPrivKey, digest);
        merkleAirdrop.claim(timo, CLAIM_AMOUNT, proof, v, r, s);
        uint256 claimedBalance = lockInToken.balanceOf(timo);
        assertEq(claimedBalance - startingBalance, CLAIM_AMOUNT);
    }

    function testGreyCanClaimForTimo() public {
        uint256 startingTimoBalance = lockInToken.balanceOf(timo);
        console.log("Starting Balance: ", startingTimoBalance);

        bytes32 digest = merkleAirdrop.getMessageHash(timo, CLAIM_AMOUNT);

        // Timo signs message
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(timoPrivKey, digest);

        // Grey claims
        vm.prank(grey);
        merkleAirdrop.claim(timo, CLAIM_AMOUNT, proof, v, r, s);

        uint256 endingTimoBalance = lockInToken.balanceOf(timo);
        console.log("Ending Balance: ", endingTimoBalance);
        assertEq(endingTimoBalance - startingTimoBalance, CLAIM_AMOUNT);
    }
}