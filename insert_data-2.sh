#! /bin/bash

# Script to insert data from games.csv into worldcup database

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != "year" ]]
  then
    # get team_id
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      # if not found
      if [[ -z $TEAM_ID_W ]]
      then
      # insert name
      INSERT_TEAM_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_TEAM_WINNER == "INSERT 0 1" ]]
        then
         echo Inserted into name: $WINNER
        fi
      fi
    
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      # if not found
      if [[ -z $TEAM_ID_O ]]
      then
      # insert name
      INSERT_TEAM_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')") 
        if [[ $INSERT_TEAM_OPPONENT == "INSERT 0 1" ]]
        then
         echo Inserted into name: $OPPONENT
        fi
      fi    
      
    #get winner_id/opponent_id from teams
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # get year, round, winner_goals, opponent_goals
    
      INSERT_REST_INFORMATION=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
        
  fi
done 