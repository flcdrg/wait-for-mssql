#!/bin/ash

delay=${delay:-3}
max=${max:-10}
server=${server:-host.docker.internal}
username=${username:-sa}
password=${password:-yourStrong(!)Password}
database=${database:-}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"

        case $param in
        delay) delay=$2;;
        max) max=$2;;
        server) server=$2;;
        username) username=$2;;
        password) password=$2;;
        database) database=$2;;
        verbose) verbose=$2;;
        *) break;
        esac;
   fi

  shift
done

state="something"
count=0

if [ "$verbose" == "true" ]; then
    ./sqlcmd --version
    echo ""
    echo "delay: $delay"
    echo "max: $max"
    echo "server: $server"
    echo "username: $username"
    echo "password: $password"
    echo "database: $database"
fi

SQLCMDPASSWORD=$password 
export SQLCMDPASSWORD
printenv

while [ "$state" != "" ]; do
    count=$((count+1))

    # -C        trust server certificate
    # -h -1     Don't print headings
    # -W        remove trailing spaces

    if [ -z "$database" ]; then
        # Check all databases
        state=`./sqlcmd -C -S $server -U $username -Q 'SET NOCOUNT ON; SELECT name, state_desc from sys.databases WHERE state NOT IN (0, 6, 10)' --headers="-1" -W -s " " `
    else
        # Check specific database - wait until it exists and is ONLINE (state = 0)
        state=`./sqlcmd -C -S $server -U $username -Q "SET NOCOUNT ON; SELECT name, state_desc from sys.databases WHERE name = '$database' AND state <> 0" --headers="-1" -W -s " " `
        
        # Also check if database exists at all
        exists=`./sqlcmd -C -S $server -U $username -Q "SET NOCOUNT ON; SELECT COUNT(*) from sys.databases WHERE name = '$database'" --headers="-1" -W`
        
        if [ "$exists" == "0" ]; then
            state="Database '$database' does not exist yet"
        fi
    fi

    if [ $? -ne 0 ]; then
        state="Error connecting"
    fi

    echo "$count of $max: $state"
    sleep $delay

    if [ $count -gt $max ]; then
        echo "Giving up after $count attempts"
        exit 1
        break;

    fi

done

if [ -z "$database" ]; then
    echo "All databases ready"
else
    echo "Database '$database' is ready"
fi