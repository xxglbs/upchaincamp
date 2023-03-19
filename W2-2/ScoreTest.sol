// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// 定义Score接口
interface IScore {

    // 增加分数
    function addScore(address student,uint256 score) external;
    // 修改分数
    function modifyScore(address student, uint256 score) external;
    // 查询分数
    function getScore(address student) external view returns(uint256);
    // 获取老师地址
    function getTeacher() external view returns(address);
}

contract Score is IScore {

    // 老师地址
    address public teacher;
    // 学生分数记录mapping
    mapping(address => uint256) scores;

    // 初始化
    constructor() {
        teacher = msg.sender;
    }


    modifier onlyTeacher {
        // 声明只有老师能够调用
        require(msg.sender == teacher, "Only teacher !");
        // 校验后继续执行原方法
        _;
    }

    function addScore(address student, uint256 score) external override onlyTeacher {
        // require(score <= 100, "Score should be no more 100 !");
        // if(scores[student] != 0) {
        //     score+=scores[student];
        // }
        require(score <= 100, "Score should be no more 100 !");
        scores[student] = score;
    }

    function modifyScore(address student, uint256 score) external override onlyTeacher {
        require(score <= 100, "Score should be no more 100 !");
        require(scores[student] > 0, "The student's score does not exist!");
        scores[student] = score;
    }

    function getScore(address student) external view override returns(uint256) {
        return scores[student];
    }

    function getTeacher() external view returns (address) {
        return teacher;
    }

}

contract Teacher {

   IScore public scoreContract;
 
    constructor(address teacherAddr) {
        scoreContract = IScore(teacherAddr);
    }

  


    function setScore(address student, uint256 score) public{
        //require(msg.sender == scoreContract.teacherAddr(), "Only teacher222 !");
        //scoreContract.addScore(student, score);
        // if (scoreContract.getScore(student) == 0) {
        //     scoreContract.addScore(student, score);
        // } else {
        //     scoreContract.modifyScore(student, score);
        // }
      //  scoreContract.addScore{value: msg.value}(student, score);
        scoreContract.addScore(student, score);
    }

    function getScore(address student) public view returns(uint256) {
        return scoreContract.getScore(student);
    }

    function getTeacher() public view returns (address) {
        return scoreContract.getTeacher();
    }
    
}
