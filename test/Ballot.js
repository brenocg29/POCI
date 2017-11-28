var Ballot = artifacts.require("./Ballot.sol");
contract('Ballot', function(accounts) {
	it("ballot should be empty",function(){
		return Ballot.deployed().then(function(instance){
			return instance.ShowResults.call();
		}).then(function(P){
			assert.equal(P[2].valueOf(),0,"The Ballot is empty");
		});
	});
	it("Voter should be added",function(){
		return Ballot.deployed().then(function(instance){
			return instance.addVoter.call("123");
		}).then(function(S){
			assert.equal(S.valueOf(),true,"voter added");
		});
	});
	it("vote should be cast",function(){
		var meta;
		return Ballot.deployed().then(function(instance){
			meta = instance;
			return meta.addVoter.call("123");
		}).then(function(balance){
			console.log(balance);
			return meta.vote.call(true,"122");
		}).then(function(balance){
			console.log("passei aki");
			return meta.ShowResults.call()
		}).then(function(E){
			assert.equal(E[0].valueOf(),1,"the vote is cast");
		});
	});
});