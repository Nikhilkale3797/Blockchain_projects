// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VOTING {
    mapping(string => uint256) private candidate;
    mapping(string => bool) private formfiller;
    mapping(string => uint256) private voter_reg;
    mapping(string => bool) private candi_unique;

    mapping(uint256 => string) private max_list;
    uint256[] private vote_log;

    function reg_candidate(string memory _name) public returns (uint256) {
        require(formfiller[_name] == false, "allready registered");
        formfiller[_name] = true;
        return candidate[_name];
    }

    function reg_voter(string memory _name, uint256 v_id) public {
        voter_reg[_name] = v_id;
        //candi_unique[nam]=true;
    }

    function caste_vote(
        uint256 id,
        string memory _name,
        string memory _candidate
    ) public {
        require(formfiller[_candidate] == true, "not registered");
        require(candi_unique[_name] == false, "you have already voted");
        require(voter_reg[_name] == id, "you are not register");
        candidate[_candidate] += 1;
        candi_unique[_name] = true;
        max_list[candidate[_candidate]] = _candidate;
        vote_log.push(candidate[_candidate]);
    }

    function result() public view returns (string memory) {
        uint256 highest = 0;
        uint256 i;

        for (i = 0; i < vote_log.length; i++) {
            if (vote_log[i] > highest) {
                highest = vote_log[i];
            }
        }
        return max_list[highest];
    }
} //end
