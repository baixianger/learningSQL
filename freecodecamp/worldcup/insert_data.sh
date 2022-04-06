#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#  = $($PSQL "")
echo $($PSQL "TRUNCATE games, teams")
# add a Internal Field Separator (IFS)
cat games.csv | while  IFS="," read YEAR ROU WIN OPP WIN_G OPP_G
do

  # filter the first row
  if [[ $YEAR != year ]]
  then

    # get the team id in winner col
    TEAM_ID=$($PSQL "select team_id from teams where name='$WIN'")
    # if not find in winner col
    if [[ -z $TEAM_ID ]]
    then
      # insert to teams
      IN_TEAM_OUT=$($PSQL "insert into teams(name) values('$WIN')")
      # check insert success
      if [[ $IN_TEAM_OUT ==  "INSERT 0 1" ]]
      then
        echo Inserted $WIN into teams.
      fi
    fi

    # get the team id in opponent col
    TEAM_ID=$($PSQL "select team_id from teams where name='$OPP'")
    # if not find in winner col
    if [[ -z $TEAM_ID ]]
    then
      # insert to teams
      IN_TEAM_OUT=$($PSQL "insert into teams(name) values('$OPP')")
      # check insert success
      if [[ $IN_TEAM_OUT ==  "INSERT 0 1" ]]
      then
        echo Inserted $OPP into teams.
      fi
    fi

    # get winner team id and opponent team id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    # insert game
    IN_GAME_OUT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROU', $WIN_ID, $OPP_ID, $WIN_G, $OPP_G)")
    if [[ $IN_GAME_OUT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR $ROU # $WIN $WIN_ID $OPP $OPP_ID $WIN_G $OPP_G
    fi

  else
    echo Skipping the first line.........
  fi
done 
