// SPDX-License-Identifier: MIT
pragma solidity > 0.6.0 < 0.9.0;
 
interface bidder_bid{
    function current_bid() external view returns (uint);
    function owner() external view returns (address payable);
}

 
contract bidder is bidder_bid{
    uint public initial_bid;
    address payable public owner;
    struct Bidder_details{
    string  name;
    uint  age;
    address payable addr;
    }
    uint public current_bid;
    modifier mfd(){
        require( owner==payable(msg.sender),"Dear candidate please don't try to check someone's balance ");
    _;
    }
    struct carinfo{
        string Name; // car name
        uint Mileage; // car mileage
        uint Year; // car bought in year
        string Type; // car type: auto or gear
        uint initial_bid; //initial bit
        }
    
    mapping(address=>carinfo) public car_info;
    function Car_Detail(string memory _name, uint _mileage, uint _year, string memory _type, uint _initial_bid) public{
        car_info[msg.sender]=carinfo(_name,_mileage,_year,_type,_initial_bid);
        owner=payable(msg.sender);
        initial_bid=_initial_bid;
    }
 
    function del(address _add) public{
        delete car_info[_add];
        delete owner;
    }

    error Err(string, address);
    mapping(uint => Bidder_details) Bid;
    function join_to_auction(string memory _name,uint _age,uint _bid) public {
    if (owner == 0x0000000000000000000000000000000000000000){
        revert Err("There is no any auction available for participate",payable(msg.sender));
    }
    else if (payable(msg.sender) == payable(owner)){
        revert Err("Owner cann't participate in auction",payable(msg.sender));
    }
    else if(current_bid < _bid && initial_bid <= _bid && 18<=_age){
        Bid[_bid]=Bidder_details(_name,_age,payable(msg.sender));
        current_bid=_bid;
    }
    else{
        revert Err(" May be you are underage to join auction or Dear participater please add more money[more then current bid] else go home with your empty pocket",payable(msg.sender));
        }
    }
}
 
contract sendetc{
    address payable owner;
    uint public final_bid;
    address payable tmp;
    error Err(string, address);
    function mybid(bidder_bid _b) public returns(uint){
        owner=_b.owner();
        final_bid=_b.current_bid();
        return _b.current_bid();
    }
    receive() external payable{}
    function remains_balance() public view returns(uint){
       return address(this).balance; // this  keyword indicates current contract balance
    }
    event log(uint value);
    function Transfer_Fund(address payable ad) payable public{ // no revert so we have to use required
        emit log(msg.value);
        // emit log();
        if (ad == owner){
        (bool sent,) = ad.call{value:final_bid}("");
       require (sent,"transaction is not done check balance or transaction amount value");
        }
        else{
            revert Err("Are you sure that you are sending your fund to car owner ?? because that is not car owner address",payable(msg.sender));
        }
    }
 
}
contract getetc{
receive() external payable {}
    address payable public owner;
    modifier mfd(){
        require( owner==payable(msg.sender),"Dear candidate please don't try to check someone's balance ");
    _;
    }
    function owner_address(bidder_bid _o) public returns(address){
        owner=payable(_o.owner());
        return payable(_o.owner());
    }
   
    function received_balance() mfd public view returns(uint){
       return address(owner).balance;
    }
}


