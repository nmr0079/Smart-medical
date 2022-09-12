App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() {
    return App.initWeb3();
  },

  //Initialize the connection between client side application and the local blockchain
  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.request({ method: "eth_requestAccounts" });;
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);


    return App.initContract();
  },

  initContract: function() {
    $.getJSON("Patient1.json", function(patient) {
      //Instantiate a new truffle contract from the artifact
      App.contracts.Patient = TruffleContract(patient);
      //Connect provider to connect with the contract
      App.contracts.Patient.setProvider(App.web3Provider);
      return App.render();
    });
  },

  render: function() {
    var patientInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    //Load account data
    web3.eth.getCoinbase(function(err, account) {
      if(err === null){
        App.account = account;
        $("accountAddress").html("Current Patient account is " + account);
      }
    });

    //Load Contract data 
    App.contracts.Patient.deployed().then(function(instance){
      patientInstance = instance;
      return patientInstance.patientsCount();
    }).then(function(count1){
      var patient_details = $("#Patient-Details");
      var account_addr = $('#accountaddress');
      var addr_acc = App.account;
      account_addr.append(addr_acc);
      patient_details.empty();
      var count =1;
      //var i = 0;
      for(var i = 0;i < count1;i++){
          patientInstance.p_List(i).then(function(ins){
             //addr = ins;
             patientInstance.getPatientDet(ins).then(function(patient) {
          //patientInstance.getPatientDet(App.account).then(function(patient) {
             var name = patient[0];
             var age = patient[1].toNumber();
             var city = patient[2];
             var hash = patient[3];
             patientInstance.getAccessList(ins).then(function(lis){
          //render patient details
            var patientTemplate = "<tr><th>"+ count + "</th><td>"+name+"</td><td>" + age + "</td><td>" + city + "</td><td>" + hash +  "</td><td>" + lis + "</tr>";
            patient_details.append(patientTemplate);
            count++;
             });
        });
      });
      }

      loader.hide();
      content.show();
    }).catch(function(error){
      console.warn(error);
    });

  },

  addDet: function() {
    var pname = $('#Pname').val();
    var page = $('#Page').val();
    var pcity = $('#Pcity').val();
    var phash = $('#Phash').val();

    App.contracts.Patient.deployed().then(function(instance){
      return instance.addDetails(pname,page,pcity,phash, {from: App.account});

  }).then(function(message) {
    $('#content').hide();
    $('#loader').show();
  }).catch(function(err) {
    console.error(err);
  });
},

giveAcc: function() {
  var daddr = $('#Daddr').val();

  App.contracts.Patient.deployed().then(function(instance1){
    return instance1.giveAccess(daddr, {from: App.account});

}).then(function(message) {
  $('#content').hide();
  $('#loader').show();
}).catch(function(err) {
  console.error(err);
});
},

revAcc: function() {
  var daddre = $('#Daddre').val();

  App.contracts.Patient.deployed().then(function(instance2){
    return instance2.revokeAccess(daddre, {from: App.account});

}).then(function(message) {
  $('#content').hide();
  $('#loader').show();
}).catch(function(err) {
  console.error(err);
});
},

getMedRec: function() {
  var daddri = $('#Daddri').val();

  App.contracts.Patient.deployed().then(function(instance2){
    return instance2.getHash(App.account, daddri, {from: App.account});

}).then(function(ipfshash) {
  document.getElementById("medrecord").onclick = function () {
		location.href = window.open("http://127.0.0.1:8080/ipfs/"+ipfshash);
  	};
  $('#content').hide();
  $('#loader').show();
}).catch(function(err) {
  console.error(err);
});

}

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
