# Wait for MSSQL

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/flcdrg/wait-for-mssql)

A script that can be run as a Docker image, which waits for a Microsoft SQL Server instance to be ready to accept connections.

When you run SQL Server in a container, it is common for the container to indicate it has started, but in fact, SQL Server is still loading databases. Trying to connect at this time to a specific database would fail.

This script waits until all databases are online. When databases are online they are ready to be used.

If it succeeds it returns 0, but if it fails to connect after a certain number of attempts it returns 1.

## Parameters

- `--server` - the name of the server hosting SQL Server
- `--username` - username
- `--password` - password
- `--database` - (optional) the name of a specific database to wait for. If not specified, waits for all databases to be ready
- `--delay` - how many seconds to wait between attempts (defaults to 3)
- `--max` - maximum number of connection attempts to make (defaults to 10)

## Examples

Connect to a default instance running on `localhost` with username `sa` and password `yourStrong(!)Password`

```bash
docker run flcdrg/wait-for-mssql:latest
```

When run on a Linux host, you need to use the [--add-host parameter](https://docs.docker.com/reference/cli/docker/container/run/#add-host):

```bash
docker run --add-host=host.docker.internal:host-gateway flcdrg/wait-for-mssql:latest
```

Connect to a default instance running on `myserver` with username `flcdrg` and password `mySuperPassword(!)`

```bash
docker run flcdrg/wait-for-mssql:latest --server myserver --username flcdrg --password mySuperPassword(!)
```

Connect to an instance running on `myserver` on port 8000 with username `sa` and password `yourStrong(!)Password`

```bash
docker run flcdrg/wait-for-mssql:latest --server myserver,8000
```

Wait for a specific database named `MyDatabase` to be ready

```bash
docker run flcdrg/wait-for-mssql:latest --database MyDatabase
```

Wait for a specific database on a custom server

```bash
docker run flcdrg/wait-for-mssql:latest --server myserver --username flcdrg --password mySuperPassword(!) --database MyDatabase
```
