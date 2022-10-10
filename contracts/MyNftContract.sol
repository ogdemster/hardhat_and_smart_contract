//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyNftContract is ERC721Enumerable, Ownable {

     using Strings for uint256;
    string _baseTokenURI;

    uint256 public _price = 0.02 ether;
    bool public _paused;

    uint256 public maxTokenIds = 10;

    // üretilen NFT için tokenId'miz burada. daha sonra bunu tokenURI oluştururken kullanacağız.
    uint256 public tokenIds;

    modifier ifContractNotPaused {
        require(!_paused, "Currently its not allowed because contract paused!!!");
        _;
    }

    //ERC721 contract oluşturuyoruz, Proje adını boşluksuz olarak burada verebilir ve Sembolünü belirleyebilirsiniz.
    constructor (string memory baseURI) ERC721("Anime Collection", "ACO") {
        _baseTokenURI = baseURI;
    }

    //Mint fonksiyonuzmu burada _safeMint metodunu kullanıyoruz.
    function mint() public payable ifContractNotPaused {
        require(tokenIds < maxTokenIds, "Token supply exceeding not allowed");
        require(msg.value >= _price, "You have not enough Ether");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    //Temel url tüm contract içinde bu şekilde kullanılabilir hale geliyor.
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    //TokenURI oluşturma fonksiyonumuz. ERC721 orjinal metodu burada değiştirilip tam url hazırlanıyor.
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "tokenId not exists");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    //Contract durduma ya da aktif etme
    function isPaused(bool pause) public onlyOwner {
        _paused = pause;
    }

    //Contract sahibi contract üzerindeki eth'leri kendine geri alabiliyor.
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Withdraw failed!!");
    }

    
    receive() external payable {}

    fallback() external payable {}
}