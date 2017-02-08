#!/bin/bash
cd /etc/ansible/roles/update-checker/

hosts=$( cat /etc/ansible/roles/update-checker/hosts.txt )

for host in $hosts; do
  hostname=$( ansible $host -m shell -a "hostname" | grep .abs.lan | sed 's/\ | SUCCESS | rc=0 >>//g' )
    echo "$hostname" > $host.tmp
  version=$( ansible $host -m shell -a "cat /etc/*-release" > $host.txt )
    cat $host.txt | grep PRETTY_NAME= | sed 's/\PRETTY_NAME=//g' | sed 's/\"//g' >> $host.tmp
    rm /etc/ansible/roles/update-checker/$host.txt
  ansible $host -m shell -a "apt-get update" #### HERE EDITED
  getstatus=$( ansible $host -m shell -a "apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print \"$1\n\"}' | wc -l" > $host.txt )
  finalgetstatus=$( cat $host.txt | sed 's/\$host.abs.lan | SUCCESS | rc=0 >>//g' )
    if [ -z "$finalgetstatus" ]
      then
        status="error getting update information"
      else
        if [ "$finalgetstatus" = "0" ]; then
          status="no packages updates available"
        else
          status="$finalgetstatus packages updates available"
        fi
    fi
  echo "$status" >> $host.tmp
  rm $host.txt
  sed -e '3d;' $host.tmp > $host.status
  rm $host.tmp
done

### Generate HTML file

htmlfile="index.html"
files=$( ls | grep status )
    echo "
    <html>
      <head>
      <link rel="stylesheet" type="text/css" href="update-styles.css">
        <div class="wrapper">
        <h1>System Updates Status</h1>
          <br>
            <br>
        <body>
          <table class="main-table">
            <th class="main-th">Host</th>
            <th class="main-th">Version</th>
            <th class="main-th">Last Checked</th>
            <th class="main-th">Status</th>
    " > $htmlfile

for file in $files; do
  lastchecked=$( date -r $file )
  version=$( head -2 $file | tail -1 )
  host=$( head -1 $file | tail -1 )
  status=$( head -3 $file | tail -1 )
  errorcheck=$( cat $file | grep "UNREACHABLE" )
  
##### New error checking added from here

    if [ ! -z "$errorcheck" ]
      then
        host=$( head -1 $file | tail -1 | sed 's/\ | UNREACHABLE! => {//g' )
        version="Unknown"
        status="Ansible is unable to contact the host (unreachable)"
    fi
    
###### End of new error checking

  getStatus () {
   echo $status | grep -Fqe "$1"
    }
  if getStatus "no packages updates available"; then
        colortr="blue-tr"
      elif getStatus "packages updates available"; then
        colortr="yellow-tr"
      else
        colortr="red-tr"
  fi
    echo      "<tr class="$colortr">
                    <td>$host</td>
                    <td>$version</td>
                    <td>$lastchecked</td>
                    <td>$status</td>
                  </tr>" >> $htmlfile
done
    echo "
            </table>
          </body>
        </div>
    </html>
      " >> $htmlfile

ansible-playbook update-html-file.yml
exit
