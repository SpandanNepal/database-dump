#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
  ELEMENTS=$($PSQL "Select * from elements where atomic_number = $1;")
  else

    if [[ $1 =~ ^.{0,2}$ ]]; then
      ELEMENTS=$($PSQL "Select * from elements where symbol = '$1';")
    else
      ELEMENTS=$($PSQL "Select * from elements where name = '$1';")
    fi

  fi

  if [[ -z $ELEMENTS ]]; then
    echo "I could not find that element in the database."
  else
    IFS='|' read ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENTS"
    ATOMIC_NUMBER=$(echo "$ATOMIC_NUMBER" | xargs)
    SYMBOL=$(echo "$SYMBOL" | xargs)
    NAME=$(echo "$NAME" | xargs)

    PROPERTIES=$($PSQL "select type_id, atomic_mass, melting_point_celsius, boiling_point_celsius
     from properties 
     where atomic_number=$ATOMIC_NUMBER;")

    IFS='|' read TYPE_ID ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$PROPERTIES"
    ATOMIC_MASS=$(echo "$ATOMIC_MASS" | xargs)
    MELTING_POINT=$(echo "$MELTING_POINT" | xargs)
    BOILING_POINT=$(echo "$BOILING_POINT" | xargs)

    TYPE=$($PSQL "select type from types where type_id=$TYPE_ID")

    TYPE=$(echo "$TYPE" | xargs)

    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi

else
  echo "Please provide an element as an argument."
fi