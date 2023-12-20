// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract DPPContract is
    ERC1155,
    ERC1155Burnable,
    ERC1155Supply,
    AccessControl,
    ERC1155URIStorage
{
    uint256 public token_id = 1;
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    uint public bikePrice = 1000 wei;
    uint public depositWheel = 200 wei;
    uint public depositFrame = 400 wei;
    uint public totalPrice = 1800 wei;

    constructor(address defaultAdmin, address minter) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(MINTER_ROLE, minter);
    }

    mapping(address => bool) public BikePayment;
    mapping(address => bool) public PayedDepositFrame;
    mapping(address => bool) public PayedDepositWheel;
    mapping(address => uint) public adressToDPP_ID;
    mapping(uint => mapping(address => bool)) public dppIdtoUsers;
    mapping(address => bool) public orderMade;
    mapping(address => string) public userOrderIPFS;
    modifier onlyNewPurchase() {
        //How can i assign access to users address in the array listuser
        require(!orderMade[msg.sender], "You already payed for a bike.");
        _;
    }

    function makePurchase(
        string memory _ipfsLink
    ) public payable onlyNewPurchase {
        // Check if price sent is valid, else revert the transaction
        require(msg.value == totalPrice, "The price received is invalid");
        require(!orderMade[msg.sender], "Already made an order");
        orderMade[msg.sender] = true;
        userOrderIPFS[msg.sender] = _ipfsLink;
        BikePayment[msg.sender] = true;
        PayedDepositFrame[msg.sender] = true;
        PayedDepositWheel[msg.sender] = true;

        // rest of your logic
    }

    function approvePurchase(
        address _user,
        string memory _dpp_ipfs_link
    ) public {
        // require(_maintainer.has(msg.sender), "DOES_NOT_HAVE_MINTER_ROLE");
        require(BikePayment[_user], "No valid Payment");
        payTo(_user, bikePrice);
        BikePayment[_user] = false;
        delete orderMade[_user];
        delete userOrderIPFS[_user];
        uri_set_mint(_dpp_ipfs_link, _user);
    }

    ////////////////////// Cancel Purchase as Distributor /////////
    function cancelPurchase_User() public {
        // require(_maintainer.has(msg.sender), "DOES_NOT_HAVE_MINTER_ROLE");
        require(BikePayment[msg.sender], "No purchase has been made to cancel"); // check if the
        payTo(msg.sender, totalPrice); // pay back the ammount to client
        delete BikePayment[msg.sender];
        delete orderMade[msg.sender];
        delete PayedDepositFrame[msg.sender];
        delete PayedDepositWheel[msg.sender];
        delete userOrderIPFS[msg.sender]; // delete IPFS instance

        // we can leave the json of the canceled order on iPFS, we are not going to call it anyway
    }

    function cancelPurchase_Distributor(address _user) public {
        // require(_maintainer.has(msg.sender), "DOES_NOT_HAVE_MINTER_ROLE");
        require(BikePayment[_user], "No purchase has been made to cancel"); // check if the
        payTo(_user, totalPrice); // pay back the ammount to client
        delete orderMade[msg.sender];
        delete BikePayment[_user];
        delete PayedDepositFrame[_user];
        delete PayedDepositWheel[_user];
        delete userOrderIPFS[_user]; // delete IPFS instance

        // we can leave the json of the canceled order on iPFS, we are not going to call it anyway
    }

    /////////////////////////////////////////////////////////////

    function payTo(address to, uint256 amount) internal returns (bool) {
        (bool success, ) = payable(to).call{value: amount}("");
        require(success, "Payment failed");
        return true;
    }

    function uri_set_mint(
        string memory tokenURI,
        address _to
    ) public onlyRole(MINTER_ROLE) {
        ERC1155URIStorage._setURI(token_id, tokenURI);
        _mint(_to, token_id, 1, "");
        token_id++;
    }

    function setURI(string memory newuri) public onlyRole(URI_SETTER_ROLE) {
        _setURI(newuri);
    }

    function uri(
        uint256 tokenId
    ) public view override(ERC1155, ERC1155URIStorage) returns (string memory) {
        return ERC1155URIStorage.uri(tokenId);
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
