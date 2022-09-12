//SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

contract Doctor {

    struct doctor {
        string name;
        uint age;
        string hos_name;
        address[] patientAccessList;
    }

    address[] public d_list;
    mapping (address => doctor) doc_Info;

    function addDetails(string memory _name, uint _age, string memory _hos_name) public returns (string memory)
    {
        doctor memory d;
        d.name = _name;
        d.age = _age;
        d.hos_name = _hos_name;
        doc_Info[msg.sender] = d;
        d_list.push(msg.sender)-1;
        return "Details added succesfully";
    }

    function getDocDet(address daddr) view public returns (string memory, uint, string memory) {
        return (doc_Info[daddr].name,doc_Info[daddr].age,doc_Info[daddr].hos_name);
    }
}
