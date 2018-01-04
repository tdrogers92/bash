#!/bin/bash

GREEN=0
YELLOW=1
RED=2
AMBER=3

for host in $(cat hosts.txt)
do
  #echo "Welcome $host times"
  FILE=$( cat $host.updates | grep -Eo '[0-3]' )
    if [ $FILE = '2' ];
      then
        #$MESSAGE=""
        printf "" > updates.errors
    fi;
    if [ $FILE = '1' ];
      #$MESSAGE=""
      printf "" >> updates.required
    fi;
    if [ $FILE = '0' ];
      then
        printf "" > updates.ok
done

## Reporting to nagios

MESSAGE=$( cat updates.errors )
  if [ z $MESSAGE ];
    then
      exit $GREEN
    else
      echo "Issues with upgrade checks for $MESSAGE"
  fi;
# Catch-all
echo "Updates error check exited in catch-all"
exit $RED

## Updates available nagios checks
MESSAGE=$( cat updates.required )
  if [ -z $MESSAGE ];
    then
      echo "All hosts are up to date"
      exit $GREEN
    else
      echo "Updates available for $MESSAGE"
      exit $YELLOW
  fi;
# Catch-all
echo "Catch-all triggered for updates.available"
exit $RED
#Updates ok nagios checks
MESSAGE=$( cat updates.ok )
  if [ -z $MESSAGE ];
    then
      echo "Updates.ok is empty!"
      exit $RED
    else
      echo "$MESSAGE"
      exit $GREEN
  fi;
# Catch-all
echo "Problem with updates.ok"
exit $RED
