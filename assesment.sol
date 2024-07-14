// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract VotingSystem {
    address public owner;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string description;
        uint256 voteCount;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public votes;

    event ProposalCreated(uint256 id, string description);
    event Voted(uint256 proposalId, address voter);
    event ProposalExecuted(uint256 id);

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProposal(string memory _description) public  {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, _description, 0, false);
        emit ProposalCreated(proposalCount, _description);
    }

    function vote(uint256 _proposalId) public {
        require(!votes[msg.sender][_proposalId], "You have already voted for this proposal");
        require(proposals[_proposalId].id != 0, "Proposal does not exist");
        require(proposals[_proposalId].executed, "Proposal is not executed yet");
        require(proposals[_proposalId].voteCount < 5, "This proposal have been passed");

        votes[msg.sender][_proposalId] = true;
        proposals[_proposalId].voteCount++;
        emit Voted(_proposalId, msg.sender);
    }

    function executeProposal(uint256 _proposalId) public onlyOwner {
        require(proposals[_proposalId].id != 0, "Proposal does not exist");
        require(!proposals[_proposalId].executed, "Proposal already executed");

        proposals[_proposalId].executed = true;
        emit ProposalExecuted(_proposalId);
    }

    function getProposal(uint256 _proposalId) public view returns (string memory description, uint256 voteCount, bool executed) {
        Proposal memory proposal = proposals[_proposalId];
        return (proposal.description, proposal.voteCount, proposal.executed);
    }
}
