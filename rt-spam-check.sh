#!/bin/bash

#Set variables ready to use
GREEN=0
YELLOW=1
RED=2
AMBER=3

SPAMFILE=/root/spam.figures
ERROR="There is an issue with the spam queue checks."
LASTCHECK=$(date)

#query RT to get all the totals into a file and add them to get a final total

rt list "queue = 'spam'" > foo.txt #| grep = | tr -d '========== ' | grep -Eo '[0-5]' > $SPAMFILE
  cat foo.txt | grep tickets | tr -d '========== ' | tr -d 'zxcvbnmlkjhgfdsaqwertyuiop' > numbers.spam


FILETEST=$(grep '[0-99]' $SPAMFILE)
  if [[ -z $FILETEST ]]
    then
      echo "Spam file is empty!"
        #exit $RED
  fi;

SPAMTOTALCOUNT=$(cat foo.txt | awk '{ sum += $1 } END { print sum }')

#Perform some basic tests on the commands run above

  if [[ $SPAMTOTALCOUNT -gt '100' ]]
    then
      echo "spam queue more than 100. Last checked: ${LASTCHECK%????????}"
        #exit $YELLOW
    else
      echo "OK- spam queue less than 100. Last checked: ${LASTCHECK%????????}"
        #exit $GREEN
  fi;

#Should have exited now so anything else exit RED

echo "$ERROR Last checked: ${LASTCHECK%????????}";
  #exit $RED


#!/bin/bash
#Set nagios flags
GREEN=0
YELLOW=1
RED=2
AMBER=3

#Set spam variables
THRESHOLD="10"
SPAMNEW=$(rt list "queue = 'spam' AND status='new'" | grep " tickets ==")
SPAMSTALLED=$(rt list "queue = 'spam' AND status='stalled'" | grep " tickets ==")
SPAMOPENED=$(rt list "queue = 'spam' AND status='open'" | grep " tickets ==")
TEMPFILE=/root/foo128663hagxd.spam
  #echo $SPAMNEW
  #echo $SPAMOPENED
  #echo $SPAMSTALLED
  printf "$SPAMNEW\n$SPAMOPENED\n$SPAMSTALLED" > $TEMPFILE
SPAMTOTALCOUNT=$(cat $TEMPFILE | grep -Eo '[0-999999]*' | awk '{ sum += $1 } END { print sum }')
rm $TEMPFILE
  #echo $SPAMTOTALCOUNT

  if [[ -z $SPAMTOTALCOUNT ]]
    then
        echo "Error: Total Spam count is null";
          exit $RED
  fi;

  if [[ $SPAMTOTALCOUNT -lt $THRESHOLD ]]
    then
      echo "Spam is below the threshold of $THRESHOLD.";
        exit $GREEN
  else
      echo "Spam total is $SPAMTOTALCOUNT with the current threshold at $THRESHOLD.";
        exit $YELLOW
  fi;
#Catch-all
echo "Error collecting spam queue information."
  exit $RED

















green=0
yellow=1
red=2
amber=3
temp1=/var/rtqueue/unowned.spam.tmp
unownedtickets=/var/rtqueue/unowned.spam
opentickets=/var/rtqueue/opentickets.spam
temp2=/var/rtqueue/open.spam.tmp
warnthreshold="20"
critthreshold="30"

rt list "queue = 'spam' AND status='new'" | grep " tickets ==" > $temp1
cat $temp1 | grep -o '[0-999]*' > $unownedtickets
rm $temp1
unownedticketsum=$( cat $unownedtickets )

rt list "queue = 'spam' AND status='open'" | grep " tickets ==" > $temp2
cat $temp2 | grep -o '[0-999]*' > $opentickets
rm $temp2
openticketsum=$( cat $opentickets )

#echo "$unownedticketsum unowned tickets"
#echo "$openticketsum opened spam tickets"

total=$(($unownedticketsum + $openticketsum))
#echo $total

  if [[ $total = "0" ]]; then
    echo "There is 0 spam in the RT spam queue"
    exit $green
  fi;

  if (($total > $critthreshold)); then
    echo "Critiacl threshold of $critthreshold triggered. Spam count is: $total"
    exit $red

  if (($total > $warnthreshold)); then
    echo "Threshold of $warnthreshold spam triggered. Total Spam count is: $total"
    exit $yellow
  else
    echo "Below threshold of $threshold for spam. Total Spam count is: $total"
    exit $green
  fi;
#Catch all
echo "Script did not exit within the IF statements"
exit $red
