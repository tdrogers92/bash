#!/bin/bash
changes="changed=0"
nochanges="changed=1"
resolvokfiletmp=/var/resolvchecks/resolv.nochanges.temp
resolvchangefiletmp=/var/resolvchecks/resolv.changes.temp
resolverrorfiletmp=/var/resolvchecks/error.resolv.temp
resolvokfiletmp2=/var/resolvchecks/resolv.nochanges.temp2
resolvchangefiletmp2=/var/resolvchecks/resolv.changes.temp2
resolverrorfiletmp2=/var/resolvchecks/error.resolv.temp2
resolvokfile=/var/resolvchecks/resolv.nochanges
resolvchangefile=/var/resolvchecks/resolv.changes
resolverrorfile=/var/resolvchecks/error.resolv
for host in $( cat hosts.txt ); do
  ansible-playbook -l $host /etc/ansible/roles/dnsconfig/tasks/resolv.yml --check > $host.temp
  nochangeresult=$( cat $host.temp | grep $nochanges)
  changeresult=$( cat $host.temp | grep $changes )

  if [[ ! -z $nochangeresult ]]; then
    echo $host >> $resolvokfiletmp
  fi;
  if [[ ! -z $changeresult ]]; then
    echo $host >> $resolvchangefiletmp
  else
    echo $host >> $resolverrorfiletmp
  fi;

done
### Trim the files for a better nagios format
sed 's/.abs.lan//g' $resolverrorfiletmp > $resolverrorfiletmp2
sed 's/.abs.lan//g' $resolvchangefiletmp  > $resolvchangefiletmp2
sed 's/.abs.lan//g' $resolvokfiletmp  > $resolvokfiletmp2
rm $resolverrorfiletmp
rm $resolvchangefiletmp
rm $resolvokfiletmp
cat $resolverrorfiletmp2 | xargs | sed -e 's/ /,/g' > $resolvokfile
cat $resolvchangefiletmp2 | xargs | sed -e 's/ /,/g' > $resolvchangefile
cat $resolvokfiletmp2 | xargs | sed -e 's/ /,/g' > $resolverrorfile
rm $resolverrorfiletmp2
rm $resolvchangefiletmp2
rm $resolvokfiletmp2










for host in $( cat hosts.txt ); do
  results=$( ansible-playbook -l $host /etc/ansible/roles/dnsconfig/tasks/resolv.yml --check > $host.temp )
    nochangeresult=$( cat $host.temp | grep $nochanges)
      if [ -z "$nochangeresult" ]; then
        changeresult=$( cat $host.temp | grep $changes )
          if [ -z "$changeresult" ]; then
            echo "$host" >> $resolverrorfiletmp
            rm $host.temp
          else
            echo "$host" >> $resolvchangefiletmp
            rm $host.temp
          fi;
      else
        echo "$host" >> $resolvokfiletmp
        rm $host.temp
      fi;
done
