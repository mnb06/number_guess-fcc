#!/bin/bash

# psql var
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# enter the username and save
echo "Enter your username:"
read USERNAME

EXIST=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME';")

if [[ -z $EXIST ]]
then
  INSERT_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games I WHERE username = '$USERNAME';")
  ATTEMPTS=$($PSQL "SELECT min(attempts) FROM games WHERE username = '$USERNAME';")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $ATTEMPTS guesses."
fi

# number generation
DIV=$((1000+1))
R=$(($RANDOM%$DIV))

echo "Guess the secret number between 1 and 1000:"
read NUMBER
declare -i I=1

while [[ $NUMBER -ne $R ]]
do
  I+=1
  if [[ -n ${NUMBER//[0-9]/} ]]; then
    echo "That is not an integer, guess again:"
    read NUMBER
  elif [[ $NUMBER -gt $R ]]
  then
    echo "It's lower than that, guess again:"
    read NUMBER
  else 
    echo "It's higher than that, guess again:"
    read NUMBER
  fi
done

echo "You guessed it in $I tries. The secret number was $R. Nice job!"

UPLOAD_DATA=$($PSQL "INSERT INTO games(username, attempts) VALUES('$USERNAME', $I);")
