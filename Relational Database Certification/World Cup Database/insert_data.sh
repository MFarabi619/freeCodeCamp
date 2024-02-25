#! /bin/bash

if [[ $1 == "test" ]]; then
	PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
	PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo $($PSQL "TRUNCATE games, teams")

# Do not change code above this line. Use the PSQL variable above to query your database.

# Ignore the first line
# Loop through each entry and add them to the database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
	if [[ $YEAR != "year" ]]; then
		# Add all teams to teams table
		# Check if winning team already exists
		TEAM_EXISTS=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		# if not found, add the team
		if [[ -z $TEAM_EXISTS ]]; then
			INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
		fi

		# Check if losing team already exists
		TEAM_EXISTS=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		# if not found, add the team
		if [[ -z $TEAM_EXISTS ]]; then
			INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
		fi

		# Insert data for games table
		# Get winner ID
		WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

		# get year
INSERT_GAME_RESULT=$($PSQL "INSERT into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

	fi
done

