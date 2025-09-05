#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Delete all the data in the tables before insert.
echo -e "$($PSQL TRUNCATE teams games)"

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != winner ]]
  then
    echo -e "\nInsert into TEAMS table"
    echo -e "$($PSQL "INSERT INTO teams(name)
       SELECT DISTINCT t
       FROM (VALUES (trim('$winner')), (trim('$opponent'))) AS s(t)
       WHERE t <> ''
       ON CONFLICT (name) DO NOTHING;")"

    echo -e "\nInsert into GAMES table"
    echo -e "$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id)
      VALUES (
        $year,
        '$round',
        $winner_goals,
        $opponent_goals,
        (SELECT team_id FROM teams WHERE name = trim('$winner')),
        (SELECT team_id FROM teams WHERE name = trim('$opponent'))
      );")"
  fi
done