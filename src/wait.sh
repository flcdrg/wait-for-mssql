#!/bin/ash

delay=${delay:-3}
max=${max:-10}
server=${server:-host.docker.internal}
username=${username:-sa}
password=${password:-yourStrong(!)Password}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"

        case $param in
        delay) delay=$2;;
        max) max=$2;;
        server) server=$2;;
        username) username=$2;;
        password) password=$2;;
        verbose) verbose=$2;;
        *) break;
        esac;
   fi

  shift
done

state="something"
count=0

if [ "$verbose" == "true" ]; then
    echo "delay: $delay"
    echo "max: $max"
    echo "server: $server"
    echo "username: $username"
    echo "password: $password"
fi

./sqlcmd --version

while [ "$state" != "" ]; do
    count=$((count+1))

    # -C        trust server certificate
    # -h -1     Don't print headings
    # -W        remove trailing spaces
    state=`./sqlcmd -C -S $server -U $username -P "$password" -Q 'SET NOCOUNT ON; SELECT name, state_desc from sys.databases WHERE state NOT IN (0, 6, 10)' -h -1 -W -s " " `

    if [ $? -ne 0 ]; then
        state="Error connecting"
    fi

    echo "$count of $max: $state"
    sleep $delay

    if [ $count -ge $max ]; then
        echo "Giving up after $count attempts"
        exit 1
        break;

    fi

done

echo "All databases ready"