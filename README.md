# AutoMyDumper Docker Image

Dockerfile for creating a Docker image that uses [AutoMySQLBackup-mydumper](https://github.com/tyzhnenko/AutoMySQLBackup-mydumper) to backup MySQL databases.

## Image Details

- Base Image: Ubuntu 22.04
- Author: Ace Dimitrievski

## Usage

This image is designed for database backups and does not run as a background service. You must provide external cron to schedule backups.

## Volume

This Docker image includes a volume at `/srv/backup/db`. You can mount this volume to a local directory on your host machine when running the container. The directory specified during the volume mounting will be used to store the MySQL database backups.

## Environment Variables

- `DBHOST`: MySQL host address.
- `PASSWORD`: MySQL password.
- `USERNAME`: MySQL username (default: root).
- `DBNAMES`: Databases to backup (default: all).
- `MAILADDR`: Email address for notifications.
- `MAILCONTENT`: Backup email content type (default: log).
- `MAXATTSIZE`: Maximum email attachment size (default: 4000).

## Logs

Backup logs are stored in the root of the volume mount point with filenames generated based on the hostname and timestamp with nanoseconds precision. For example, a log filename may appear as "mysql.myorg.org-094847951.log," where "mysql.myorg.org" represents the hostname, and "094847951" is the timestamp.

- `LOGFILE`: Contains detailed backup information.
- `LOGERR`: Contains error logs, prefixed with "ERRORS_."

These logs provide insights into the backup process and any encountered errors.

## Build and Run

```bash
docker build -t automydumper .
docker run -e DBHOST=mydb.myorg.org -e PASSWORD=my_strong_password -v /my/local/backup/path:/srv/backup/db automydumper
```
