// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract Web3NFTContract is ERC1155, Ownable, Pausable, ERC1155Supply {
    bool publicMintOpen = true;
    uint256 publicMintPrice = 0.01 ether;
    uint256 publicMintLimit = 3;
    mapping (address => uint) publicMintCount;
    mapping (address => bool) ReservedMintList;
    bool ReservedMintOpen = false;
    uint256 ReservedMintPrice = 0.005 ether;
    uint256 ReservedMintLimit = 5;
    mapping (address => uint) ReservedMintCount;

    constructor()
        ERC1155("ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/c")
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function publicMint(uint256 id, uint256 amount)
        public
        payable
    {
        require(msg.value == publicMintPrice * amount, "Not enough ETH sent; check price!");
        require(publicMintOpen, "Public minting is closed!");
        require(publicMintCount[msg.sender] + amount <= publicMintLimit, "Minting limit reached!");
        _mint(msg.sender, id, amount,"");
        publicMintCount[msg.sender] += amount;
    }

    function ReservedMint(uint256 id, uint256 amount) public payable
    {
        require(msg.value >= ReservedMintPrice * amount, "Not enough ETH sent; check price!");
        require(ReservedMintOpen, "Reserved minting is closed!");
        require(ReservedMintList[msg.sender], "You are not on the reserved list!");
        require(ReservedMintCount[msg.sender] + amount <= ReservedMintLimit, "Minting limit reached!");
        _mint(msg.sender, id, amount,"");
        ReservedMintCount[msg.sender] += amount;
    }

    function togglePublicMint() public onlyOwner {
        publicMintOpen = !publicMintOpen;
    }
    function toggleReservedMint() public onlyOwner {
        ReservedMintOpen = !ReservedMintOpen;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}