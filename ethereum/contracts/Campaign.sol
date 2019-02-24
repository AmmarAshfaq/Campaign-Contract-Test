pragma solidity ^0.4.17;

contract CampaignFactory{
    address[] public deployedCampaigns;
    function createCampaign(uint minimum) public{
        address newCampaign = new Campaign(minimum,msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    function getDeployedCampaigns() public view returns (address[]){
        return deployedCampaigns;
    }
}
contract Campaign {
    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
        
    }
    address public manager;
    uint public minimumContribution;
    // address [] public approvers; //replace with mapping because mapping take constant times
    mapping(address => bool) public approvers;
    uint public approversCount;
    Request[] public requests;
    
     modifier restricted(){
        require(msg.sender == manager);
        _;
    }
    function Campaign(uint minimum,address creator) public{
        manager = creator;
        minimumContribution = minimum;
        approversCount++;
    }
    // mapping:collection of key value pairs.Same as js objects.but all key and value of the same type.
    //struct : collection of key value pairs that can have different types.
    // modifier is a function use to restrict the un authenticated user to access or run operations
    // storage and memory (Some times references where our contract store data)(Some times reference how our solidity variables store values)
    // storage and memory are data holding places. Storage are holds data b/w fumction cals same as hard drive.Memory Tmporary places to store data.RAm like
    // every contract variable store in the storage area,argument variable are like a memory
    function contribute() public payable{
        require(msg.value >minimumContribution);
        // approvers.push(msg.sender);
        approvers[msg.sender] = true;
    }
    // array is linear time search
    // mapping is constant time search
    // In mapping key are not stored.we are working on hashing function.In hash table we are having a loopup process.
    //In mapping we create hashing through lookup process.where we assign key in hashing function and its return index of the value.
    // In mapping values are not iterable means we cannot fetch all values
    //In mapping all values exist which means if we assign a key in hash function it returns value instead of undefined.
    function createRequest(string description,uint value,address recipient) public restricted{
        // we have only set the value here which is value type not refernce type
        Request memory newRequest = Request({
            description:description,
            value:value,
            recipient:recipient,
            complete:false,
            approvalCount:0
            
        });
        requests.push(newRequest);
    }
    
    
    function approverRequest(uint index) public{
        Request storage request = requests[index];
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    function finalizeRequest(uint index) public restricted{
        Request storage request = requests[index];
        
        require(request.approvalCount>(approversCount/2));
        require(!request.complete);
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }
}