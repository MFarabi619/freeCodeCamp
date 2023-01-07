import "./App.scss";
import Button from "react-bootstrap/Button";
import "bootstrap/dist/css/bootstrap.min.css";
import "./custom.scss";
import React, { useState, useEffect } from "react";
import { colorArray } from "./colors";

let quotesDBUrl =
  "https://gist.githubusercontent.com/camperbot/5a022b72e96c4c9585c32bf6a75f62d9/raw/e3c6895ce42069f0ee7e991229064f167fe8ccdc/quotes.json";

function App() {
  const [quoteArray, setQuoteArray] = useState(null);

  const fetchQuotes = async (url) => {
    //fetches and parses data from url
    const response = await fetch(url);
    const parsedJSON = await response.json();
    setQuoteArray(parsedJSON.quotes);
  };

  useEffect(() => {
    //Called after page loads
    fetchQuotes(quotesDBUrl);
  }, [quotesDBUrl]);

  const randomizer = (array) => {
    //Returns random elements from array passed into it
    return array[Math.floor(Math.random() * array.length)];
  };

  const [quote, setQuote] = useState("");
  const [author, setAuthor] = useState("");
  const [color, setColor] = useState(randomizer(colorArray));

  const handleChange = () => {
    let randomColor = randomizer(colorArray);
    setColor(randomColor);

    let randomQuote = randomizer(quoteArray);
    setQuote(randomQuote.quote);
    setAuthor(randomQuote.author);
  };

  useEffect(() => {
    //Displays a random quote once page loads
    if (quoteArray) {
      handleChange();
    }
  }, [quoteArray]);

  return (
    <div className="App">
      <header
        className="App-header"
        style={{ backgroundColor: `${color}`, color: `${color}` }}
      >
        <wrapper id="quote-box">
          <p id="text">
            <i className="fa fa-quote-left"></i>
            <span> </span>
            {quote}
          </p>
          <p id="author">- {author}</p>
          <div className="buttons">
            <a
              id="tweet-quote"
              href={encodeURI(
                `http://www.twitter.com/intent/tweet?text="${quote}" \n\n - ${author}`
              )}
            >
              <Button className="tweet-button">
                <i className="fa fa-twitter"></i>
              </Button>
            </a>
            <Button id="new-quote" onClick={handleChange}>
              New quote
            </Button>
          </div>
        </wrapper>
        <p className="credits">By Mumtahin Farabi</p>
      </header>
    </div>
  );
}

export default App;
