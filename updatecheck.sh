#!/bin/bash
GREEN="updates.ok"
RED="updates.error"
YELLOW="updates.required"
UPTODATETEXT="The following packages will be upgraded:"
NOUPDATETEXT="0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded."
CHECKRESULT=$( apt-get --just-print upgrade )

CHECK1=$( $CHECKRESULT | grep "The following packages will be upgraded" )
  if [[ -z $CHECK1 ]];
    then
      CHECK2=$( $CHECKRESULT | grep "0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded." )
        if [[ -z $CHECK2 ]];
          then
            echo "ERROR NO TEXTS FOUND"
            exit
        fi;
  fi;




  if [[ -z $CHECKRESULT ]];
    then
      MSG="apt-get result is null"
      echo "$MSG" > $RED
      exit
  fi;
    if grep -q "$UPTODATETEXT" <<<$CHECKUPDATES;
      then
        #echo "Upgrades available"
        echo "Updates are available"
      exit
    fi;
        if grep -q "$NOUPDATETEXT" <<<$CHECKUPDATES;
          then
            #echo "No Upgrades available"
            echo "no updates available"
            exit
      else
         #echo "ERROR Exiting...."
         echo "ERROR"
         echo "$CHECKRESULT"
         exit
    fi;
