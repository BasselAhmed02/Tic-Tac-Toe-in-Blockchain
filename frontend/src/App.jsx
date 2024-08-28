// import React, { useState, useEffect } from "react";
// import { ethers } from "ethers";
// import contractABI from "./TicTacToeABI2.json";
// import { Icon } from "@iconify/react";

// const contractAddress = "0x2E9d30761DB97706C536A112B9466433032b28e3";

// function App() {
//   const [board, setBoard] = useState(Array(9).fill(null));
//   const [playerAddress, setPlayerAddress] = useState(null);
//   const [gameOver, setGameOver] = useState(false);
//   const [message, setMessage] = useState("Welcome to Tic-Tac-Toe!");
//   const [contract, setContract] = useState(null);

//   useEffect(() => {
//     if (window.ethereum) {
//       window.ethereum
//         .request({ method: "eth_requestAccounts" })
//         .then((accounts) => setPlayerAddress(accounts[0]))
//         .catch((err) => console.log(err));

//       const provider = new ethers.BrowserProvider(window.ethereum);
//       const signer = provider.getSigner();
//       const gameContract = new ethers.Contract(
//         contractAddress,
//         contractABI,
//         signer
//       );
//       setContract(gameContract);

//       gameContract.getBoard().then((board) => setBoard(board));
//     }
//   }, []);

//   const handleClick = async (index) => {
//     if (contract && !gameOver) {
//       try {
//         const tx = await contract.makeMove(index);
//         await tx.wait();
//         const newBoard = await contract.getBoard();
//         setBoard(newBoard);

//         contract.once("GameOver", (winner, result) => {
//           if (winner === ethers.constants.AddressZero) {
//             setMessage("It's a draw!");
//           } else if (winner === playerAddress) {
//             setMessage("You win!");
//           } else {
//             setMessage("The bot wins!");
//           }
//           setGameOver(true);
//         });
//       } catch (error) {
//         console.log(error);
//       }
//     }
//   };

//   return (
//     <div className="min-h-screen flex flex-col items-center bg-gradient-to-r from-green-400 to-blue-500">
//       <header className="w-full bg-white shadow-md py-4">
//         <div className="container mx-auto flex justify-around items-center">
//           <h1 className="text-2xl font-bold text-gray-800">Tic-Tac-Toe</h1>
//           <div className="flex items-center space-x-4">
//             <Icon
//               icon="mdi:gamepad-variant-outline"
//               width="32"
//               height="32"
//               className="text-gray-600"
//             />
//             <p className="text-gray-600">
//               Player: {playerAddress ? playerAddress : "Not connected"}
//             </p>
//           </div>
//         </div>
//       </header>

//       <div className="bg-white p-8 rounded-xl shadow-lg mt-32">
//         <h1 className="text-3xl font-bold text-center mb-4">Tic-Tac-Toe</h1>
//         <p className="text-center mb-6">{message}</p>
//         <div className="grid grid-cols-3 gap-4">
//           {board.map((cell, index) => (
//             <div
//               key={index}
//               onClick={() => handleClick(index)}
//               className="w-16 h-16 flex items-center justify-center bg-gray-200 text-2xl font-bold cursor-pointer"
//             >
//               {cell === 1 ? "O" : cell === 2 ? "X" : ""}
//             </div>
//           ))}
//         </div>
//       </div>
//     </div>
//   );
// }

// export default App;

import React, { useState } from "react";

const App = () => {
  const [grid, setGrid] = useState(Array(9).fill(null));
  const [currentSymbol, setCurrentSymbol] = useState("X");

  const handleClick = (index) => {
    const newGrid = [...grid];
    if (newGrid[index]) {
      newGrid[index] = null;
    } else {
      newGrid[index] = currentSymbol;
    }
    setGrid(newGrid);
  };

  const changeSymbol = (symbol) => {
    setCurrentSymbol(symbol);
  };

  return (
    <div className="min-h-screen flex flex-col justify-between bg-gradient-to-r from-green-400 via-blue-500 to-purple-600">
      <nav className="bg-yellow-500 shadow-md p-4">
        <h1 className="text-2xl font-bold text-center text-gray-700">
          Tic Tac Toe
        </h1>
      </nav>

      <div className="flex flex-col items-center justify-center flex-grow">
        <div className="flex space-x-4 mb-8">
          <button
            onClick={() => changeSymbol("X")}
            className="px-6 py-2 bg-blue-500 text-white rounded-lg shadow hover:bg-blue-700 focus:outline-none"
          >
            X
          </button>
          <button
            onClick={() => changeSymbol("O")}
            className="px-6 py-2 bg-green-500 text-white rounded-lg shadow hover:bg-green-700 focus:outline-none"
          >
            O
          </button>
        </div>

        <div className="grid grid-cols-3 gap-4 w-64">
          {grid.map((value, index) => (
            <div
              key={index}
              onClick={() => handleClick(index)}
              className="flex items-center justify-center w-20 h-20 bg-white border-2 border-gray-300 rounded-lg shadow cursor-pointer text-3xl font-bold"
            >
              {value}
            </div>
          ))}
        </div>
      </div>

      <footer className="bg-black text-center py-2">
        <p className="text-gray-500">
          &copy; 2024 Tic Tac Toe. All rights reserved.
        </p>
      </footer>
    </div>
  );
};

export default App;
