// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UpdateToken is ERC20{

    constructor() ERC20("My test token", "XDT") {
        _mint(msg.sender, 20000 * 10 ** decimals());
    }
}

contract UpdateToken2 is ERC20 {

    constructor() ERC20("My test token", "XDT") {
        _mint(msg.sender, 30000 * 10 ** decimals());
    }

    function transferWithCallback(address recipient, uint256 amount) external returns (bool){
        _transfer(msg.sender, recipient, amount);
        // emit TransferWithCallback(msg.sender, recipient, amount);
        return true;
    }

    //event TransferWithCallback(address indexed from, address indexed to, uint256 value);
}

contract UTProxy {
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1);
        address public owner;

        constructor() {
            owner = msg.sender;
        }

    

     function _delegate(address _implementation) internal virtual {
        assembly {

            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                // revert(p, s) - end execution, revert state changes, return data mem[p…(p+s))
                revert(0, returndatasize())
            }
            default {
                // return(p, s) - end execution, return data mem[p…(p+s))
                return(0, returndatasize())
            }
        }
    }

    // 代理到 Counter
    function _fallback() private {
        _delegate(_getImplementation());
    }

    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }

    // 分别代理到 Counter
    // function delegateTransfer(address token, address recipient, uint256 amount) external {
    //     bytes memory callData = abi.encodeWithSignature("transferWithCallback(address,uint256)", recipient, amount);
    //     (bool ok,) = token.delegatecall(callData);
    //     if(!ok) revert("Delegate call failed");
    // }

    function delegateTransfer(address recipient, uint256 amount) external {
        bytes memory callData = abi.encodeWithSignature("transferWithCallback(address,uint256)", recipient, amount);
        (bool ok,) = address(recipient).delegatecall(callData);
        if(!ok) revert("Delegate call failed");
    }

    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function _setImplementation(address _implementation) private {
        require(_implementation.code.length > 0, "implementation is not contract");
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _implementation;
    }

    function upgradeTo(address _implementation) external {
        require(msg.sender == owner, "only owner can upgrade implementation");
        _setImplementation(_implementation);
    }


}


library StorageSlot {
    struct AddressSlot {
        address value;
    }

    function getAddressSlot(
        bytes32 slot
    ) internal pure returns (AddressSlot storage r) {
        assembly {
            r.slot := slot
        }
    }
}