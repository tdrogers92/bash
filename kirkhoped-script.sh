#!/bin/bash
hosts=$( cat /etc/ansible/roles/update-checker/hosts.txt )
for host in $hosts; do

hostname=$( ansible $host -m shell -a "hostname" | grep .abs.lan | sed 's/\ | SUCCESS | rc=0 >>//g' )
  echo "$hostname" > $host.tmp
version=$( ansible $host -m shell -a "cat /etc/*-release" > $host.txt )
cat $host.txt | grep PRETTY_NAME= | sed 's/\PRETTY_NAME=//g' | sed 's/\"//g' >> $host.tmp
  rm /etc/ansible/roles/update-checker/$host.txt
ansible $host -m command -a "apt-get update"
getstatus=$( ansible $host -m shell -a "apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print \"$1\n\"}' | wc -l" > $host.txt )
  finalgetstatus=$( cat $host.txt | sed 's/\$host.abs.lan | SUCCESS | rc=0 >>//g' )
  if [ -z "$finalgetstatus" ]
    then
      status="error getting update information"
    else
      if [ "$finalgetstatus" = "0" ]; then
        status="$finalgetstatus package updates available"
        else
          status="$finalgetstatus package updates available"
      fi
  fi
echo "$status" >> $host.tmp
rm $host.txt
sed -e '3d;' $host.tmp > $host.status
rm $host.tmp
done
exit