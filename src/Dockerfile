FROM alpine AS base

RUN apk add curl

ARG TARGETARCH
# https://github.com/microsoft/go-sqlcmd/releases
RUN curl -L -o sqlcmd.tar.bz2 https://github.com/microsoft/go-sqlcmd/releases/download/v1.8.0/sqlcmd-linux-${TARGETARCH}.tar.bz2
RUN ls -al

RUN tar -xvf sqlcmd.tar.bz2

RUN ls -al

# SQL Server Command Line Tools
# From https://raw.githubusercontent.com/microsoft/mssql-docker/master/linux/mssql-tools/Dockerfile.alpine
FROM alpine

LABEL maintainer="David Gardiner"

COPY --from=base sqlcmd .

COPY wait.sh .

ENTRYPOINT [ "./wait.sh" ]
