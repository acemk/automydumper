# Dockerfile for automydumper
# Description: Uses https://github.com/tyzhnenko/AutoMySQLBackup-mydumper to backup mysql databases
# Base image: ubuntu:22.04
# Author: Ace Dimitrievski
# Version: 0.2
# Date: 2023-11-01
# Usage: Environment variables DBHOST and PASSWORD must be provided. This image does not have a cron built in and will exit as soon as the backup is completed. For daily backups you must provide external cron that will run this container, it will not run in background.
# Build: docker build -t automydumper .
# Run: docker run --network OPTIONAL_MY_NETWORK -e USERNAME=my_mysql_user -e PASSWORD=my_strong_password -e DBHOST=mydb.myorg.org -e MAILADDR=me@myorg.org -v /my/local/backup/path:/srv/backup/db automydumper

# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables with default values (placeholders)
ENV USERNAME=root \
    DBNAMES=all \
    MAILCONTENT="log" \
    MAXATTSIZE="4000" \
    MAILADDR="maintenance@example.com" \
    ROTATION_DAILY="6" \
    ROTATION_WEEKLY="35" \
    ROTATION_MONTHLY="150"

# Update package repositories and install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mydumper mailutils gawk mariadb-client bzip2

RUN mkdir -p /srv/backup/db
VOLUME /srv/backup/db

# Copy the automysqlbackup executable to /usr/local/bin/
COPY automysqlbackup.sh /usr/local/bin/

# Set executable permissions for automysqlbackup
RUN chmod +x /usr/local/bin/automysqlbackup.sh

# Copy the entrypoint.sh executable to the root folder. The entry point will call automysqlbackup.sh.
COPY entrypoint.sh /entrypoint.sh

# Set executable permissions for /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Cleanup package cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]
