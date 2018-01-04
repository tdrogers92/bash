#!/bin/bash

cd /var/update-checker/
htmlfile="/var/www/updates/index.html"
files=$( ls | grep status )

echo "
<html>
  <head>
  <link rel="stylesheet" type="text/css" href="update-styles.css">
    <h1></h1>
    <body>
      <table>
        <th>Host</th>
        <th>Operating System</th>
        <th>Current Version</th>
        <th>Last Checked</th>
        <th>Status</th>
" > $htmlfile

  for file in $files; do
    lastchecked=$( date -r $file )
    host=$( head -1 $file | tail -1 )
    operatingsystem=$( head -2 $file | tail -1 )
    currentversion=$( head -3 $file | tail -1 )
    status=$( head -4 $file | tail -1 )
    if [ "$status" = "Updates available" ]; then
      color="yellow"
    else
      color="blue"
    fi
    echo      "<tr class="$color-tr">
                <td>$host</td>
                <td>$operatingsystem</td>
                <td>$currentversion</td>
                <td>$lastchecked</td>
                <td>$status</td>
              </tr>" >> $htmlfile
  done

  echo "
        </table>
      </body>
</html>
  " >> $htmlfile

exit
