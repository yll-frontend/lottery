const {network} = require("hardhat");
const {developmentChains} = require("../helper-hardhat-config");

const BASE_FEE = ethers.utils.parseEther("0.25");
const GAS_PRICE_LINK = 1e9;

module.exports = async function({getNamedAccounts,deployments})=> {
  const {deploy,log} = deployments;
  const {deployer} = await getNamedAccounts();
  const chainId  =network.config.chainId;
  if (developmentChains.includes(network.name)) {
    log("local network detected! Deploying mocks...")
    await deploy('VRFCoordinatorV2Mock',{
      form:deployer,
      log:true,
      args:[BASE_FEE,GAS_PRICE_LINK]
    })
  }
}

module.exports.tags = ['all','mocks']