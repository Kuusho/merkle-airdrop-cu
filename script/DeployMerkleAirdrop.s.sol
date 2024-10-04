//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {LockInToken} from "../src/LockInToken.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract DeployMerkleAirdrop is Script{
    LockInToken lockInToken;
    MerkleAirdrop merkleAirdrop;

    function run(bytes32 root) external returns(LockInToken, MerkleAirdrop) {
        vm.startBroadcast();
        lockInToken = new LockInToken();
        merkleAirdrop = new MerkleAirdrop(root, lockInToken);
        lockInToken.transferOwnership(msg.sender);
        vm.stopBroadcast();
        return (lockInToken, merkleAirdrop);
    }
}