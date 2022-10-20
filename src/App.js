import { useState } from "react";
import "./App.css";
import MainMint from "./MainMint";
import NavBar from "./NavBar";

function App() {
  // useState is a hook that lets you add a piece of state to your component
  const [accounts, setAccounts] = useState([]);

  return (
    <div className="overlay">
      <div className="App">
        <NavBar accounts={accounts} setAccounts={setAccounts} />
        <MainMint accounts={accounts} setAccounts={setAccounts} />
      </div>
      <div className="moving-background"></div>
    </div>
  );
}

export default App;
