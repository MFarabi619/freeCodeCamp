#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$((RANDOM % 1000 + 1))

echo "Enter your username:"
read USERNAME

# Check if username already exists and get their data
USER_DATA=$($PSQL "SELECT username, games_played, best_game FROM users_games WHERE username = '$USERNAME'")

if [[ -z $USER_DATA ]]; then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    # Add user to database with no games played yet
    $($PSQL "INSERT INTO users_games (username, games_played, best_game) VALUES ('$USERNAME', 0, NULL)")
else
    IFS='|' read -r DB_USERNAME GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read NUMBER_GUESS
TRIES_NUMBER=1
VALID_GUESS=false

while [[ $VALID_GUESS == false ]]
do
  if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    read NUMBER_GUESS
  elif [[ $NUMBER_GUESS -lt $SECRET_NUMBER ]]; then
    echo "It's higher than that, guess again:"
    read NUMBER_GUESS
    TRIES_NUMBER=$((TRIES_NUMBER+1))
  elif [[ $NUMBER_GUESS -gt $SECRET_NUMBER ]]; then
    echo "It's lower than that, guess again:"
    read NUMBER_GUESS
    TRIES_NUMBER=$((TRIES_NUMBER+1))
  else
    VALID_GUESS=true
  fi
done

echo "You guessed it in $TRIES_NUMBER tries. The secret number was $SECRET_NUMBER. Nice job!"

# Update user data in database
$($PSQL "UPDATE users_games SET games_played = games_played + 1 WHERE username = '$USERNAME'")

if [[ -z $BEST_GAME ]] || [[ $TRIES_NUMBER -lt $BEST_GAME ]]; then
    $($PSQL "UPDATE users_games SET best_game = $TRIES_NUMBER WHERE username = '$USERNAME'")
fi

exit 0