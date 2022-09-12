const Patient = artifacts.require("Patient");
const Patient1 = artifacts.require("Patient1");
const Doctor = artifacts.require("Doctor");

module.exports = function (deployer) {
  deployer.deploy(Patient);
  deployer.deploy(Patient1);
  deployer.deploy(Doctor);

};