// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.24;

// import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
// import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
// import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

// error Not_EnoughEthEntered(uint256 entranceFee);
// error TransferFailed();
// error LotteryNotOpen();

// abstract contract Lottery is VRFConsumerBaseV2Plus, AutomationCompatible {
//     uint256 private immutable i_entranceFee;
//     address payable[] private s_players;
//     address private s_recentWinner;
//     uint256 private s_state;
//     enum State {
//         OPEN,
//         CALCULATING
//     }
//     State private s_lotteryState;
//     uint256 private s_lastTimestamp;
//     uint256 private immutable s_interval;

//     event LotteryEnter(address indexed player);
//     event RequestLotteryWinner(uint256 indexed requestId);
//     event WinnerPicked(address indexed winner);

//     uint256 private immutable s_subscriptionId;
//     bytes32 public keyHash =
//         0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
//     uint32 private callbackGasLimit = 100000;
//     uint16 private constant requestConfirmations = 3;
//     uint32 public numWords = 2;

//     constructor(
//         address vrfCoordinatorV2,
//         uint256 entranceFee,
//         uint256 subscriptionId,
//         bytes32 _keyHash,
//         uint32 _callbackGasLimit,
//         uint256 interval
//     ) VRFConsumerBaseV2Plus(vrfCoordinatorV2) {
//         i_entranceFee = entranceFee;
//         s_subscriptionId = subscriptionId;
//         keyHash = _keyHash;
//         callbackGasLimit = _callbackGasLimit;
//         s_lotteryState = State.OPEN;
//         s_lastTimestamp = block.timestamp;
//         s_interval = interval;
//     }

//     function enterLottery() external payable {
//         if (msg.value < i_entranceFee) {
//             revert Not_EnoughEthEntered(i_entranceFee);
//         }
//         if (s_lotteryState != State.OPEN) {
//             revert LotteryNotOpen();
//         }
//         s_players.push(payable(msg.sender));
//         emit LotteryEnter(msg.sender);
//     }

//     function checkUpKeep(
//         bytes memory
//     ) public override returns (bool upkeepNeeded, bytes memory) {
//         bool isOpen = (State.OPEN == s_lotteryState);
//         bool timePassed = ((block.timestamp - s_lastTimestamp) > s_interval);
//         bool hasPlayers = (s_players.length > 0);
//         bool hasBalance = (address(this).balance > 0);
//         upkeepNeeded = (isOpen && timePassed && hasPlayers && hasBalance);
//     }

//     function performUpkeep(bytes calldata) external override {
//         (bool upkeepNeeded, ) = checkUpKeep(bytes(""));
//         require(upkeepNeeded, "Upkeep not needed");
//         requestRandomWinner(false);
//     }

//     function requestRandomWinner(
//         bool enableNativePayment
//     ) public returns (uint256) {
//         s_lotteryState = State.CALCULATING;

//         uint256 requestId = s_vrfCoordinator.requestRandomWords(
//             VRFV2PlusClient.RandomWordsRequest({
//                 keyHash: keyHash,
//                 subId: s_subscriptionId,
//                 requestConfirmations: requestConfirmations,
//                 callbackGasLimit: callbackGasLimit,
//                 numWords: numWords,
//                 extraArgs: VRFV2PlusClient._argsToBytes(
//                     VRFV2PlusClient.ExtraArgsV1({
//                         nativePayment: enableNativePayment
//                     })
//                 )
//             })
//         );

//         return requestId;
//     }

//     function fulfillRandomWords(
//         uint256,
//         uint256[] calldata _randomWords
//     ) internal override {
//         uint256 indexOfWinner = _randomWords[0] % s_players.length;
//         address payable recentWinner = s_players[indexOfWinner];
//         s_recentWinner = recentWinner;
//         s_lotteryState = State.OPEN;
//         s_players = new address payable[](0);
//         s_lastTimestamp = block.timestamp;
//         (bool success, ) = recentWinner.call{value: address(this).balance}("");
//         if (!success) {
//             revert TransferFailed();
//         }
//         emit WinnerPicked(s_recentWinner);
//     }

//     function getEntranceFee() public view returns (uint256) {
//         return i_entranceFee;
//     }

//     function getPlayer(uint256 index) public view returns (address) {
//         return s_players[index];
//     }

//     function getRecentWinner() public view returns (address) {
//         return s_recentWinner;
//     }

//     function getLotteryState() public view returns (State) {
//         return s_lotteryState;
//     }

//     function getNumWords() public view returns (uint256) {
//         return numWords;
//     }
// }
