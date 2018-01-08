#!/bin/bash
green="updates.ok"
yellow="updates.required"
red="updates.error"
host=$(hostname)
  check1=$( apt-get --just-print upgrade | grep "The following packages will be upgraded")
    if [[ -z $check1 ]];
      then
        echo "$host" > $yellow
        exit
    fi;

check2=$(apt-get --just-print upgrade | grep "0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded")
    if [[ -z $check2 ]];
      then
        echo "$host" > $green
        exit
    else
        echo "$host" > $red
        exit
    fi;
echo "$host" > $red
exit

#!bin/bash
sshpass -p "passw0rd" scp -r bob@hostname.fqdn.com:/var/updates/$host.ok /var/updates/$host.ok
sshpass -p "passw0rd" scp -r bob@hostname.fqdn.com:/var/updates/$host.required /var/updates/$host.required
sshpass -p "passw0rd" scp -r bob@hostname.fqdn.com:/var/updates/$host.error /var/updates/$host.error

#!/bin/bash
$hosts = "gnat-dev", "web"

for $host in $hosts
  do
    sshpass -p "passw0rd" scp -r bob@hostname.fqdn.com:/var/updates/$host.ok /var/updates/$host.ok
    sshpass -p "passw0rd" scp -r bob@hostname.fqdn.com:/var/updates/$host.required /var/updates/$host.required
    sshpass -p "passw0rd" scp -r bob@hostname.fqdn.com:/var/updates/$host.error /var/updates/$host.error
done

for $host in $hosts
  do
    if [ -e $host.ok ];
      then
            echo "$host" >> ok.hosts
    fi;
      if [ -e $host.required ];
        then
          echo "$host" >> required.hosts
      fi;
      if [ -e $host.error ];
        then
          echo "$host" >> error.hosts
        else
          echo "$host" >> error.hosts
      fi;
done

## Error finding
GREEN=0
YELLOW=1
RED=2
AMBER=3






#!/bin/bash
date=$(date +"%b"-"%d"-"%y")
file="$date-magento-dir.tar.gz"
logfile=/home/tom/logs/backups.log
timestamp=$(date)
        if [[ -e $file  ]];
                then
                msg="backup file found"
        else
                msg="backup file was not found"
        fi;
        printf "$timestamp:$msg" > $logfile

####
updatesavailabletext="The following packages will be upgraded:"





#!/bin/bash
updatesavailabletext="The following packages will be upgraded:"
for host in $( cat /home/tom/hosts.txt ); do
    ansible $host -m command -a "apt-get --just-print upgrade" > $host.temp.updates
    status=$( cat $host.temp.updates | grep "$updatesavailabletext" )
    if [ -z "$status" ]; then
      echo "0" > $host.status
      rm $host.temp.updates
    else
      echo "1" > $host.status
    rm $host.temp.updates
  fi;
done


### SYSTEM ERROR CHECKING
GREEN=0
YELLOW=1
AMBER=3
RED=2
errorfile=/var/updates/errors.hosts

for host in $( cat /var/updates/hosts.txt ); do
  status=$( cat $host.status )
    if [ -z $status ]; then
      echo $host >> $errorfile
    fi;
done
# Check the error file to see if it's not empty
error=$( cat $errorfile )
  if [ -z "$error" ]; then
    echo "Error file is empty"
    exit $GREEN
  else
    echo "System update errors for $( cat $errorfile )"
    exit $RED
  fi;
# Catch-all
echo "Problem with system update checks"
exit $RED


### UPDATES OK FOR HOSTS
#!/bin/bash
GREEN=0
YELLOW=1
AMBER=3
RED=2

for host in $( cat /var/updates/hosts.txt ); do
  status=$( cat $host.status )
    if [[ $status = "0" ]]; then
      echo "$host" >> updates.ok
    fi;
done
updatesokfile=$( cat /var/updates/updates.ok )
  if [ -z "$updatesokfile" ]; then
    echo "All systems require updates or have errors"
    exit $YELLOW
  else
    echo "Updates are OK for $( cat $updatesokfile )"
    exit $GREEN
  fi;
#catch-all
echo "Check did not exit correctly"
exit $RED

### UPDATES AVAILABLE HOSTS

GREEN=0
YELLOW=1
AMBER=3
RED=2
updatesavailablefile=/var/updates/updates.required

for host in $( cat /var/updates/hosts.txt ); do
  status=$( cat $host.status )
    if [[ $status = "1" ]]; then
      echo "$host" >> $updatesavailablefile
    fi;
done
    if [ -z "$updatesavailablefile" ]; then
    echo "All systems are up to date";
    exit $GREEN
    else
    echo "Updates are available for $( cat $updatesavailablefile )"
    exit $YELLOW
  fi;
#catch-all
echo "Check did not exit correctly"
exit $RED

























#!/bin/bash
updatesavailabletext="The following packages will be upgraded:"
updatesokfile=/var/updates/updates.ok
updatesreqfile=/var/updates/updates.required
updateserrorfile=/var/updates/updates.error
updatesokfiletemp=/var/updates/updates.ok.tmp
updatesreqfiletemp=/var/updates/updates.required.tmp
  if [ -e $updatesokfiletemp ]; then
      rm $updatesokfiletemp
      touch $updatesokfiletemp
  else
      touch $updatesokfiletemp
  fi;
  if [ -e $updatesreqfiletemp ]; then
      rm $updatesreqfiletemp
      touch $updatesreqfiletemp
  else
      touch $updatesreqfiletemp
  fi;
  if [ -e $updatesreqfile ]; then
    rm $updatesreqfile
    touch $updatesreqfile
  else
    touch $updatesreqfile
  fi;
  if [ -e $updatesokfile ]; then
    rm $updatesokfile
    touch $updatesokfile
  else
    touch $updatesokfile
  fi;
  if [ -e $updateserrorfile ]; then
    rm $updateserrorfile
    touch $updateserrorfile
  else
    touch $updateserrorfile
  fi;
for host in $( cat /var/updates/hosts.txt ); do
    ansible $host -m command -a "apt-get --just-print upgrade" > /var/updates/$host.temp.updates
    status=$( cat /var/updates/$host.temp.updates | grep "$updatesavailabletext" )
    if [ -z "$status" ]; then
      echo "$host" >> $updatesokfiletemp
      rm /var/updates/$host.temp.updates
    else
      echo "$host" >> $updatesreqfiletemp
      rm /var/updates/$host.temp.updates
  fi;
  done
oktemp2=/var/updates/updates.ok.tmp2
reqtemp2=/var/updates/updates.req.tmp2

sed 's/.hostname.fqdn.com//g' $updatesreqfiletemp > $reqtemp2
sed 's/.hostname.fqdn.com//g' $updatesokfiletemp  > $oktemp2
cat $reqtemp2 | xargs | sed -e 's/ /,/g' > $updatesreqfile
cat $oktemp2 | xargs | sed -e 's/ /,/g' > $updatesokfile
rm $updatesokfiletemp
rm $updatesreqfiletemp
rm $oktemp2
rm $reqtemp2












### UPDATES AVAILABLE HOSTS
#!/bin/bash
GREEN=0
YELLOW=1
AMBER=3
RED=2
updatesavailablefile=/var/updates/updates.required
  if [ -e $updatesavailablefile ]; then
    status=$( cat $updatesavailablefile )
      if [ -z "$status" ]; then
        echo "All systems are up to date"
        exit $GREEN
      else
        echo "Updates are available for $status"
        exit $YELLOW
      fi;
else
echo "updates.required does not exist."
exit $RED
fi;
#Catch-all
echo "Issue with updates available checks"
exit $RED

### UPDATES OK HOSTS
#!/bin/bash
GREEN=0
YELLOW=1
AMBER=3
RED=2
updatesokfile=/var/updates/updates.ok
  if [ -e $updatesokfile ]; then
    status=$( cat $updatesokfile )
      if [ -z "$status" ]; then
        echo "No Systems are up to date"
        exit $YELLOW
      else
        echo "Updates are OK for $status"
        exit $GREEN
      fi;
else
echo "updates.ok does not exist."
exit $RED
fi;
#Catch-all
echo "Issue with updates OK checks"
exit $RED

### UPDATES ERROR HOSTS
#!/bin/bash
GREEN=0
YELLOW=1
AMBER=3
RED=2
updateserrorfile=/var/updates/updates.errors
  if [ -e $updateserrorfile ]; then
    status=$( cat $updateserrorfile )
      if [ -z "$status" ]; then
        echo "No Systems have update check issues"
        exit $GREEN
      else
        echo "Update checks issues with $status"
        exit $RED
      fi;
else
echo "updates.error does not exist."
exit $RED
fi;
#Catch-all
echo "Issue with updates OK checks"
exit $RED
