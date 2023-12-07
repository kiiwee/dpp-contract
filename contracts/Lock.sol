
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Roles.sol";

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract DPP is ERC1155, AccessControl, ERC1155Burnable, ERC1155Supply {
    using Roles for Roles.Role;

    Roles.Role private _minters;
    Roles.Role private _maintainers;
    Roles.Role private _users;
    Roles.Role private _recyclers;
    Roles.Role private _minters;
    Roles.Role private _destributors;


    Roles.Role private _burners;
             public mapping (address => uint) adressToDPP_ID;
    public mapping (uint=>mapping(address=>bool)) dppIdtoUsers;
    constructor() ERC1155("") {
        _admin.add(msg.sender);
    }
    function setURI(string memory newuri) public onlyRole(URI_SETTER_ROLE) {
        _setURI(newuri);
    }
    function setMaintainer(address maintainer, bool state){
                require(_maintainers.has(msg.sender), "DOES_NOT_HAVE_MAINTAINER_ROLE");

        if state{
            _maintainers.add(minters[i]);

        }
        else {
            _maintainers.remove(minters[i]);

        }
    }
        function setUsers(address maintainer, bool state){
                            require(_users.has(msg.sender), "DOES_NOT_HAVE_USER_ROLE");

        if state{
            _users.add(minters[i]);

        }
        else {
            _users.remove(minters[i]);

        }
    }

        function setRecycler(address maintainer, bool state){
                            require(_recyclers.has(msg.sender), "DOES_NOT_HAVE_RECYCLER_ROLE");

        if state{
            _recyclers.add(minters[i]);

        }
        else {
            _recyclers.remove(minters[i]);

        }
    }
        function setDestributor(address maintainer, bool state){
                            require(_destributorss.has(msg.sender), "DOES_NOT_HAVE_RECYCLER_ROLE");

        if state{
            _destributors.add(minters[i]);

        }
        else {
            _destributors.remove(minters[i]);

        }
    }



   modifier onlyByOwner(uint _dppID) {
      require(
         adressToDPP_ID[msg.sender] == _dppID,
         "Sender not authorized."
      );
      _;
   }
    modifier onlyusers(uint _dppID) {
        //How can i assign access to users address in the array listuser
      require(
         dppIdtoUsers[_dppID][msg.msg.sender],
         "Sender not authorized."
      );
    }
    function recycleDPP(uint _dppID) public onlyByOwner(_dppID){

    }
    function StartMaintanance(uint _dppID)public onlyByOwner{

    }
    function EndMaintanance(uint _dppID)public onlyByOwner{

    }
      function EndMaintanance(uint _dppID)public onlyByOwner{

    }
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyRole(MINTER_ROLE) {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyRole(MINTER_ROLE) {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
