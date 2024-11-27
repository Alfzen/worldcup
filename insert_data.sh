#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")"

cat games.csv | tail -n +2 | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNERG OPPONENTG
do
RESULT="$($PSQL "SELECT 1 FROM teams WHERE name = '$OPPONENT' LIMIT 1;")"
RESULT2="$($PSQL "SELECT 1 FROM teams WHERE name = '$WINNER' LIMIT 1;")"
if [[ -n $RESULT ]]
then
echo $OPPONENT Ya está en la tabla
else
echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
fi
if [[ -n $RESULT2 ]]
then
echo $WINNER Ya está en la tabla
else 
echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
fi

WINNERID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")"
OPPONENTID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")"

echo "$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR,'$ROUND',$WINNERG,$OPPONENTG,$WINNERID,$OPPONENTID);")"


done

#