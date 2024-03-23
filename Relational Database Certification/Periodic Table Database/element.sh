#/bin/env bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT_ARGUMENT=$1

if [[ -z $ELEMENT_ARGUMENT ]]; then
    echo "Please provide an element as an argument."
    exit 0
fi

# Check if argument is a number, letter, or string
# Make query to fetch the name, atomic number, symbol, weight, melting point, boiling point
if [[ $ELEMENT_ARGUMENT =~ ^[0-9]+$ ]]; then
    RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$ELEMENT_ARGUMENT;")
else
    RESULT=$($PSQL "SELECT * FROM elements WHERE symbol ILIKE '$ELEMENT_ARGUMENT' OR name ILIKE '$ELEMENT_ARGUMENT';")
fi

# If it doesn't exist
if [[ -z $RESULT ]]; then
    echo "I could not find that element in the database."
    exit 0
fi

IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< "$RESULT"
RESULT=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON properties.atomic_number = elements.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE symbol='$SYMBOL';")
IFS='|' read -r TYPE WEIGHT MELTING_POINT BOILING_POINT <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
