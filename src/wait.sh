#!/bin/ash

# -C        trust server certificate
# -h -1     Don't print headings
# -W        remove trailing spaces

state="something"
count=0

while [ "$state" != "" ]; do
    count=$((count+1))

    state=`/opt/mssql-tools18/bin/sqlcmd -C -S host.docker.internal -U sa -P 'yourStrong(!)Password' -Q 'SET NOCOUNT ON; SELECT name, state_desc from sys.databases WHERE state NOT IN (0, 6, 10)' -h -1 -W -s " " `

    if [ $? -ne 0 ]; then
        state="Error connecting"
    fi

    echo "$count: $state"
    sleep 3

    if [ $count -ge 10 ]; then
        echo "Giving up after $count attempts"
        exit 1
        break;

    fi

done

echo "All databases ready"