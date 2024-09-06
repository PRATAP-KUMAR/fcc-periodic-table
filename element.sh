#!/bin/bash

PSQL="psql -U freecodecamp periodic_table --tuples-only -c"
PARAMETER=$1

if [[  -z $PARAMETER  ]]
then
  echo Please provide an element as an argument.
  exit
fi

if [[ $PARAMETER =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$PARAMETER
elif [ "${#PARAMETER}" -le 2 ]
then
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol = '$PARAMETER'")
else
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name = '$PARAMETER'")
fi

if [[ -z $ATOMIC_NUMBER ]]
then
  echo "I could not find that element in the database."
  exit
fi

JOIN=$($PSQL "select * from elements join properties using (atomic_number) join types using (type_id) where atomic_number = $ATOMIC_NUMBER")

echo "$JOIN" | while read t_id foo atm_n foo s foo n foo atm_mass foo mps foo bps foo t;
do
echo "The element with atomic number $atm_n is $n ($s). It's a $t, with a mass of $atm_mass amu. $n has a melting point of $mps celsius and a boiling point of $bps celsius."
done
