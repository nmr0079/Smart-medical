//SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

contract Patient1{

    struct patient {
        string name;
        uint age;
        string city;
        address[] doctorAccessList;
        address[] prescAccessList;
        string record_hash;
        
    }

    address owner_p;
    address[] public p_List;
    uint public patientsCount;

    mapping (address => patient) public patientInfo;
     
    mapping (address => bool) public doctors;

    mapping (address => bool) public pharmacy;

    mapping(address => mapping(string => string)) prescriptions;

    event detailsAdded(address _patient, string message);
    event accessGiven(address _doctor, string message);
    event accessRevoked(address _doctor, string message);
    event prescrAdded(address _doctor, string message);

     modifier only_owner(){
        require(owner_p == msg.sender);
        _;
    }

    constructor() public {
        owner_p = msg.sender;
        //patientsCount = 0;
    }
    
    function addDetails(string memory _name, uint _age, string memory _city) public returns (string memory)
    {
        patient memory p;
        p.name = _name;
        p.age = _age;
        p.city = _city;
        patientInfo[msg.sender] = p;
        p_List.push(msg.sender)-1;
        //p_List[patientsCount] = msg.sender;
        patientsCount++;

        emit detailsAdded(msg.sender, "Details of the patient has been added successfully");
        return "Details added succesfully";
    }

    function getPatientDet(address paddr) view public returns (string memory, uint, string memory, string memory) {
        return (patientInfo[paddr].name,patientInfo[paddr].age,patientInfo[paddr].city,patientInfo[paddr].record_hash);
    }
    
    function giveAccess(address _doctor_address) public returns (string memory) {
       
        require(doctors[_doctor_address] == false, "Access already given to the doctor");
        doctors[_doctor_address] = true;
        patientInfo[msg.sender].doctorAccessList.push(_doctor_address)-1;
        //an event can be added
        emit accessGiven(_doctor_address, "Access given to the above addressed doctor");
        return "Access granted";
    }
    
    //only owner is removed temporarily
    function revokeAccess(address _doctor_address) public returns (string memory) {
       
        //if(doctors[_doctor_address]){
        //    doctors[_doctor_address] = false;
        //}
        require(doctors[_doctor_address] == true, "The Doctor doesn't have any access");
        doctors[_doctor_address] = false;
        patientInfo[msg.sender].doctorAccessList.pop();
        //can add an event
        emit accessRevoked(_doctor_address, "Access has been revoked from the doctor");
        return "Access is revoked";
    }

    function getAccessList(address paddr) view public returns (address[] memory){
        return patientInfo[paddr].doctorAccessList;
    }

    function getHash(address paddr, address _doctor_address) public view returns (string memory) {
        require(doctors[_doctor_address] == true, "The Doctor doesn't have any access");
        return patientInfo[paddr].record_hash;
    }

    function addPrescriptions(address daddr, string memory disease_name, string memory medications) public returns(string memory){
        require(doctors[daddr] == true, "The Doctor doesn't have the permission to give out prescriptions");
        prescriptions[daddr][disease_name] = medications;
        emit prescrAdded(daddr, 'Prescriptions added');
        return 'Prescriptions added';

    }

    function giveAccessPrescr(address _pharma_address) public returns (string memory) {
        require(pharmacy[_pharma_address] == false, "Access to the prescriptions already given to the pharmacy");
        pharmacy[_pharma_address] = true;
        patientInfo[msg.sender].prescAccessList.push(_pharma_address)-1;
        //an event can be added
        emit accessGiven(_pharma_address, "Access to the prescriptions given to the above addressed pharmacy");
        return "Access granted";
    }

    function revokeAccessPrescr(address _pharma_address) public returns (string memory) {
        require(pharmacy[_pharma_address] == true, "This particular pharmacy doesn't have any access");
        pharmacy[_pharma_address] = false;
        patientInfo[msg.sender].prescAccessList.pop();
        //can add an event
        emit accessRevoked(_pharma_address, "Access has been revoked from the pharmacy");
        return "Access is revoked";
    }

    function getPrescriptions(address _doc_addr, address _ph_addr, string memory _disease_name) public view returns (string memory){
         require(pharmacy[_ph_addr] == true, "The pharmacy doesn't have the permission to access the prescriptions");
         return prescriptions[_doc_addr][_disease_name];   
    }

    function setIPFShash(string memory _hash)public returns(string memory){
        patientInfo[msg.sender].record_hash = _hash;
        return "IPFS hash added successfully";

    }


}