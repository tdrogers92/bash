#!/bin/bash

HOSTS=$( cat hosts.txt )
PASSWORD="Welcome123"
USERNAME="bob"

for fn in $HOSTS;
  do
    sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USERNAME@$HOSTS.abs.lan 'bash -s' < local.sh > output.txt
        echo "$HOSTSTATUS"
  done



### Local.sh

#!/bin/bash
HOSTS=$( cat hosts.txt )
PASSWORD="Welcome123"
USERNAME="bob"
sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USERNAME@$HOSTS.abs.lan 'cat /home/bob/updates.status' > output.txt


#!/bin.bash
for fn in 'cat hosts.txt';
  do
