const networkConfig = {
  11155111: {
    name: "sepolia",
    vrfCoordinatorV2: "0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B",
    entranceFee: "100000000000000000",
    gasLane:
      "0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae",
    subscriptionId: "0",
  },
  31337: {
    name: "hardhat",
    entranceFee: "100000000000000000",
    gasLane:
      "0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae",
  },
};
const developmentChains = ["hardhat", "sepolia"];

module.exports = {
  networkConfig,
  developmentChains,
};
