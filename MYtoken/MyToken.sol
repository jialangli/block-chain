// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// 引入Context.sol合约
import "../MYtoken/Context.sol";

contract Mytoken is Context{
    string private _name; // 代币名称
    string private _symbol; // 代币符号
    uint8 private _decimals; // 小数点位数
    uint256 private _totalSupply; // 总供应量
    mapping(address => uint256) private _balances; // 地址余额映射
    mapping(address => mapping(address => uint256)) private _allowances; // 授权额度映射

    // 构造函数，初始化代币名称、符号和总供应量，部署合约时调用
    constructor() {
        _name = "LJLCoin";
        _symbol = "LJLC";
        _decimals = 18;
        _mint(_msgSender(), 100 * 10000 * 10 ** _decimals);
    }

    // 返回代币名称
    function name() public view returns (string memory) {
        return _name;
    }

    // 返回代币符号
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    // 返回小数点位数
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    // 返回总供应量
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // 返回指定地址的余额
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    // 返回所有者对spender的授权额度
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    // 内部函数，用于铸造代币并分发给指定地址
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        _balances[account] += amount;
    }

    // 内部函数，实现地址之间的代币转账操作
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= amount, "ERC20: insufficient balance");
        
        _balances[from] -= amount;
        _balances[to] += amount;
        
        emit Transfer(from, to, amount);
    }

    // 对外提供的代币转账函数
    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    // 对外提供的授权函数
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    // 对外提供的代币转账授权函数
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        _spendAllowance(from, _msgSender(), amount);
        _transfer(from, to, amount);
        return true;
    }

    // 内部函数，用于授权一个地址可使用的代币额度
    function _approve(address owner, address spender, uint256 amount) internal {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    // 内部函数，用于扣除授权额度
    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= amount, "ERC20: insufficient allowance");

        unchecked {
            _approve(owner, spender, currentAllowance - amount);
        }
    }

    // 代币转账事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // 授权事件
    event Approval(address indexed owner, address indexed spender, uint256 value);
}