#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=userdetails --tuples-only -c"

NUM=$(( RANDOM % 1000 + 1 ))
echo $NUM

echo "Enter your username:"
read USER_NAME

USER_DETAIL=$($PSQL "select * from gameusers where name='$USER_NAME'")

if [[ -z $USER_DETAIL ]]; then
  INSERT_USER=$($PSQL "insert into gameusers(name) values('$USER_NAME')")
  echo -e "\nWelcome, $USER_NAME! It looks like this is your first time here."
else
  IFS='|' read NAME USER_ID BEST_GAME GAME_PLAYED <<< "$USER_DETAIL"
  BEST_GAME=$(echo "$BEST_GAME" | xargs)
  GAME_PLAYED=$(echo "$GAME_PLAYED" | xargs)
  echo -e "\nWelcome back, $USER_NAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
fi

USER_GUESS=0
COUNTER=0
echo -e "Guess the secret number between 1 and 1000:"
while [ $NUM != $USER_GUESS ]
do 
  read USER_GUESS
  COUNTER=$((COUNTER + 1))
  
  if ! [[ $USER_GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  elif [[ $NUM = $USER_GUESS ]]; then
    echo -e "\nYou guessed it in $COUNTER tries. The secret number was $NUM. Nice job!"
  elif [[ $USER_GUESS > $NUM ]]; then
    echo "It's lower than that, guess again:"
  else 
    echo "It's higher than that, guess again:"
  fi

done

UPDATE_GAME_PLAYED=$($PSQL "UPDATE gameusers set game_played=game_played+1 where name='$USER_NAME'")
if [[ $BEST_GAME < $COUNTER && $BEST_GAME != 0 ]]; then
UPDATE_BEST_GAME=$($PSQL "UPDATE gameusers set best_game=$COUNTER where name='$USER_NAME'")
fi
