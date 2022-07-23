# Wait for MSSQL

A script that can be run as a Docker image that waits for a Microsoft SQL Server instance to be ready to accept connections.

When you run SQL Server in a container, it is common for the container to indicate it has started, but in fact SQL Server is still loading databases,
and trying to connect to a specific database would fail. 

This script waits until all databases are online. When databases are online they are ready to be used.
