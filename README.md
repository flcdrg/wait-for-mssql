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
- `--delay` - how many seconds to wait between attempts
- `--max` - maximum number of connection attempts to make

## Examples

Connect to a default instance running on `localhost` with username `sa` and password `yourStrong(!)Password`

```bash
docker run flcdrg/wait-for-mssql
```

```bash
docker run flcdrg/wait-for-mssql --server myserver --username flcdrg --password mySuperPassword(!)
```

```bash
docker run flcdrg/wait-for-mssql --server myserver,8000
```
