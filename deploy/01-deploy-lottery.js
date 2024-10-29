const {network,ethers} = require("hardhat");
const {developmentChains,networkConfig} = require("../helper-hardhat-config");

module.exports = async function({getNamedAccounts,deployments})=> {
  const {deploy,log} = deployments;
  const {deployer} = await getNamedAccounts();
  const chainId  =network.config.chainId;
  let vrfCoordinatorV2Address;
  let subscriptionId;
  if (developmentChains.includes(network.name)) {
    const vrfCoordinatorV2Mock = await ethers.get("VRFCoordinatorV2Mock");
    vrfCoordinatorV2Address = vrfCoordinatorV2Mock.address;  
    const transactionResponse = await vrfCoordinatorV2Mock.createSubscription();
    const transactionReceipt = await transactionResponse.wait(1);
    subscriptionId = transactionReceipt.events[0].args.subId;
    await vrfCoordinatorV2Mock.fundSubscription(subscriptionId,ethers.utils.parseEther("5"))
  }else {
    vrfCoordinatorV2Address = networkConfig[chainId]['vrfCoordinatorV2'];  
    subscriptionId = networkConfig[chainId]['subscriptionId']
  }

  const entranceFee = networkConfig[chainId]['entranceFee']
  const gasLane = networkConfig[chainId]['gasLane']
  const lottery = await deploy("Lottery",{
    from: deployer,
    args: [vrfCoordinatorV2Address,entranceFee],
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  })
}