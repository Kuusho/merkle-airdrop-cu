//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {LockInToken} from "../src/LockInToken.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract DeployMerkleAirdrop is Script{
    LockInToken lockInToken;
    MerkleAirdrop merkleAirdrop;
    bytes32 private constant ROOT = 0x18f83611f6b600e7a43e9f3c3a81d79d0e67d558c916513c61e698527ec9ba26;
    uint256 public s_amountToTransfer = 4 * 25 * 1e18;

    function _deployMerkleAirdrop() internal returns(MerkleAirdrop, LockInToken) {
        vm.startBroadcast();
        lockInToken = new LockInToken();
        merkleAirdrop = new MerkleAirdrop(ROOT, IERC20(address(lockInToken)));
        // lockInToken.transferOwnership(msg.sender);
        lockInToken.mint(lockInToken.owner(), s_amountToTransfer);
        lockInToken.transfer(address(merkleAirdrop), s_amountToTransfer);
        vm.stopBroadcast();
        return (merkleAirdrop, lockInToken);
    }

    function run() external returns(MerkleAirdrop, LockInToken) {
        return _deployMerkleAirdrop();
    }
}