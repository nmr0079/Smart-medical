//SPDX-License-Identfier: MIT

pragma solidity ^0.5.0;

contract Pharmacy{

    struct pharma {
        string ph_name;
        string city;
        string state;
    }

    address owner_ph;
    uint public pharma_count;

    modifier only_owner(){
        require(owner_ph == msg.sender);
        _;
    }

    constructor() public {
        owner_ph = msg.sender;
    }

    /*function addDet(string memory name, string memory city, string memory state ) public returns (string memory)
    {
        pharma memory pharma;
        pharma.ph_name = name;
        pharma.city = city;
        pharma.state = state;

        pharma_count++;

        emit detailsAdded(msg.sender, "Details of the pharmacy has been added successfully");
        return "Details added succesfully";
    }*/





}