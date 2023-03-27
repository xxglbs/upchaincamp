// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

// 可以记录不同 NFT 的售价，以及哪个用户拥有该 NFT；
// 可以将用户的 NFT 转移至市场合约中，实现拍卖等功能；
// 可以购买市场中的 NFT。
contract NFTMarket is IERC721Receiver{

   mapping(uint256 => uint256) public tokenIdPrice;  // 记录每个 NFT 的售价，key 为 tokenId，value 为 price

    // immutable 是 Solidity 0.8.0 版本中引入的一个新特性，它用于声明变量不可变。
    address public immutable token;  // 记录 NFT 所使用的代币地址
    address public immutable nftToken;  // 记录 NFT 合约地址

    // 初始化
    constructor(address _token, address _nftToken) {
        token = _token;  // 将传入的代币地址赋值给 token
        nftToken = _nftToken;  // 将传入的 NFT 合约地址赋值给 nftToken
    }

    // 实现 ERC721Receiver 接口的 onERC721Received 方法
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // 将指定的 NFT 添加至市场中，并设置售价
    function list(uint tokenID, uint amount) public {
        // 调用 IERC721 接口的 safeTransferFrom 方法，将 NFT 从用户地址转移到合约地址
        IERC721(nftToken).safeTransferFrom(msg.sender, address(this), tokenID, "");
        tokenIdPrice[tokenID] += amount;  // 设置 NFT 的售价
    }

    // 购买市场中的指定 NFT
    function buy(uint tokenId, uint amount) external {
        require(amount >= tokenIdPrice[tokenId], "low price!");  // 判断支付的代币数量是否足够购买 NFT
        require(IERC721(nftToken).ownerOf(tokenId) == address(this), "aleady selled !");  // 判断 NFT 是否已经被购买
        // 调用 IERC20 接口的 transferFrom 方法，将用户支付的代币转移至合约地址
        IERC20(token).transferFrom(msg.sender, address(this), tokenIdPrice[tokenId]);
        // 调用 IERC721 接口的 transferFrom 方法，将合约地址
    }


}