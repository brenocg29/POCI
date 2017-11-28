pragma solidity ^0.4.0;
contract owner{
    address Owner;
   function owner(){
        Owner = msg.sender;
    }
    modifier Owned(){
        require(msg.sender == Owner);
        _;
    }
    function transferOwnership(address newOwner) Owned{
        Owner = newOwner;
    }
}

contract Ballot is owner{
    
    struct Proposal {
        mapping(bool => uint) voteCount;
        uint256 startTime;
        uint256 endTime;
        uint TotalVotes;
    }
    struct audit{
        uint time;
        bytes32 blockHash;
        bool Vote;
    }
    audit[] AuditData;
    Proposal P;
    mapping(string => bool) voters;
    mapping (string=>bool) voted;
    event Voted(string voter,uint Total);
    event VoterAdded(string voter);
    event PrivilegeRemoved(string voter);
    event ShowTrueFalse(uint T, uint F);
    event auditing(uint256 voteyes,uint256 voteno, bytes32 blockH);
    function Ballot(uint256 _startTime, uint256 _endTime) {
        P.voteCount[true] = 0;
        P.voteCount[false] = 0;
        P.TotalVotes = 0;
        P.startTime = _startTime;
        P.endTime = _endTime;
    }
    modifier between(uint256 _startTime, uint256 _endTime){
        assert(now>=_startTime && now <=_endTime);
        _;
    }
    modifier afterDeadline(uint256 _endTime){
        assert(now >=_endTime);
        _;
    }
    function addVoter(string voter) returns (bool) {
        voters[voter] = true;
        VoterAdded(voter);
        return voters[voter];
    }
    function ShowResults()  returns (uint,uint,uint){
       ShowTrueFalse(P.voteCount[true],P.voteCount[false]);
        return (P.voteCount[true],P.voteCount[false],P.TotalVotes);
        
    }
    function vote (bool Option,string voter) returns (string,uint){
        require(voters[voter] == true);
        require(voted[voter] == false);
        P.voteCount[Option] += 1;
        P.TotalVotes += 1;
        voted[voter] = true;
        audit temp;
        temp.time = now;
        temp.Vote = Option;
        AuditData.push(temp);
        Voted(voter,P.TotalVotes);
        return(voter,P.TotalVotes);
    }
    function RemovePrivileges(string voter) {
        require (voters[voter] == true);
        voters[voter] = false;
        PrivilegeRemoved(voter);
    }
    function AuditVotes()  {
        auditing(P.voteCount[true], P.voteCount[false],block.blockhash(block.number));
    }
    
}