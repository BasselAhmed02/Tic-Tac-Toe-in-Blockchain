// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TicTacToe {
    address public player1;
    address public player2;
    address public bot;
    uint8[9] public board; // 0 = empty, 1 = O, 2 = X
    uint public moves;
    bool public gameOver;
    bool public isPlayer1Turn;
    bool public isPvP; // true for PvP, false for PvB

    event MoveMade(address indexed player, uint8 position, uint8 mark);
    event GameOver(address winner, string result);
    event GameReset();

    constructor(bool _isPvP) {
        isPvP = _isPvP;
        if (!isPvP) {
            bot = address(this); // Bot is controlled by the contract
        }
    }

    modifier onlyPlayer() {
        require(msg.sender == player1 || (isPvP && msg.sender == player2), "Not a registered player");
        _;
    }

    modifier onlyWhenGameActive() {
        require(!gameOver, "Game is over");
        _;
    }

    function registerPlayer() public {
        // Prevent the same player from registering as both player1 and player2
        require(msg.sender != player1 && msg.sender != player2, "You are already registered as a player");

        require(player1 == address(0) || (isPvP && player2 == address(0)), "All players are registered");

        if (player1 == address(0)) {
            player1 = msg.sender;
        } else if (isPvP && player2 == address(0)) {
            player2 = msg.sender;
        }

        // Automatically reset the board once both players are registered
        if (isPvP && player1 != address(0) && player2 != address(0)) {
            resetBoard();
        } else if (!isPvP && player1 != address(0)) {
            resetBoard();
        }
    }

    function resetBoard() public {
        require(msg.sender == player1 || msg.sender == player2, "Only registered players can reset the board");
        for (uint8 i = 0; i < 9; i++) {
            board[i] = 0;
        }
        moves = 0;
        gameOver = false;
        isPlayer1Turn = true;
        emit GameReset();
    }

    function makeMove(uint8 position) public onlyPlayer onlyWhenGameActive {
        require(position < 9 && board[position] == 0, "Invalid move");

        uint8 mark;
        if (isPvP) {
            require(
                (isPlayer1Turn && msg.sender == player1) || (!isPlayer1Turn && msg.sender == player2),
                "Not your turn"
            );
            mark = isPlayer1Turn ? 1 : 2;
            board[position] = mark;
            isPlayer1Turn = !isPlayer1Turn;
        } else {
            require(msg.sender == player1, "Only player1 can make a move");
            mark = 1;
            board[position] = mark;
        }
        moves++;

        emit MoveMade(msg.sender, position, mark);

        if (checkWin(mark)) {
            gameOver = true;
            emit GameOver(msg.sender, "Player Wins");
            return;
        } else if (moves == 9) {
            gameOver = true;
            emit GameOver(address(0), "Draw");
            return;
        }

        if (!isPvP) {
            botMove();
        }
    }

    function botMove() private onlyWhenGameActive {
        uint8 botPosition = findWinningMove(2); // Check if bot can win
        if (botPosition == 9) {
            botPosition = findWinningMove(1); // Check if bot needs to block player
            if (botPosition == 9) {
                botPosition = randomAvailablePosition(); // Choose random if no win/block move
            }
        }
        
        board[botPosition] = 2; // Bot marks X
        moves++;

        emit MoveMade(bot, botPosition, 2);

        if (checkWin(2)) {
            gameOver = true;
            emit GameOver(bot, "Bot Wins");
        } else if (moves == 9) {
            gameOver = true;
            emit GameOver(address(0), "Draw");
        }
    }

    function findWinningMove(uint8 mark) private view returns (uint8) {
        for (uint8 i = 0; i < 9; i++) {
            if (board[i] == 0) { // Check if the position is available
                uint8[9] memory tempBoard = board;
                tempBoard[i] = mark;
                if (checkWinWithBoard(tempBoard, mark)) {
                    return i;
                }
            }
        }
        return 9; // Return 9 if no winning/blocking move is found
    }

    function checkWinWithBoard(uint8[9] memory tempBoard, uint8 mark) private pure returns (bool) {
        uint8[3][8] memory winPositions = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ];
        for (uint8 i = 0; i < winPositions.length; i++) {
            if (
                tempBoard[winPositions[i][0]] == mark &&
                tempBoard[winPositions[i][1]] == mark &&
                tempBoard[winPositions[i][2]] == mark
            ) {
                return true;
            }
        }
        return false;
    }

    function randomAvailablePosition() private view returns (uint8) {
        uint8 availablePositionsCount = 0;
        for (uint8 i = 0; i < 9; i++) {
            if (board[i] == 0) {
                availablePositionsCount++;
            }
        }
        uint8 randomIndex = uint8(block.timestamp % availablePositionsCount);
        uint8 availablePosition = 0;
        for (uint8 i = 0; i < 9; i++) {
            if (board[i] == 0) {
                if (randomIndex == 0) {
                    availablePosition = i;
                    break;
                }
                randomIndex--;
            }
        }
        return availablePosition;
    }

    function checkWin(uint8 mark) private view returns (bool) {
        uint8[3][8] memory winPositions = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ];
        for (uint8 i = 0; i < winPositions.length; i++) {
            if (
                board[winPositions[i][0]] == mark &&
                board[winPositions[i][1]] == mark &&
                board[winPositions[i][2]] == mark
            ) {
                return true;
            }
        }
        return false;
    }

    function getBoard() public view returns (uint8[9] memory) {
        return board;
    }
}
