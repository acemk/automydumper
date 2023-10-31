#!/bin/sh
if [ -z "$PASSWORD" ] || [ -z "$DBHOST" ]; then
  echo "You must provide the hostname and password as enfironment variables!"
  echo "Usage:"
  echo "docker run --network OPTIONAL_MY_NETWORK -e USERNAME=my_mysql_user -e PASSWORD=my_strong_password -e DBHOST=mydb.myorg.org -e MAILADDR=me@myorg.org -v /my/local/backup/path:/srv/backup/db"
  echo "Defaults: "
  echo "  USERNAME    = root"
  echo "  DBNAMES     = all"
  echo "  MAILCONTENT = log"
  echo "  MAXATTSIZE  = 4000"
  echo "  MAILADDR    = maintenance@example.com"
  echo "ERROR: No backup was created."
  exit 1
fi
sed -i "s/USERNAME_PLACEHOLDER/$USERNAME/g" /etc/automysqlbackup/automysqlbackup.conf
sed -i "s/PASSWORD_PLACEHOLDER/$PASSWORD/g" /etc/automysqlbackup/automysqlbackup.conf
sed -i "s/DBHOST_PLACEHOLDER/$DBHOST/g" /etc/automysqlbackup/automysqlbackup.conf
sed -i "s/DBNAMES_PLACEHOLDER/$DBNAMES/g" /etc/automysqlbackup/automysqlbackup.conf
sed -i "s/MAILCONTENT_PLACEHOLDER/$MAILCONTENT/g" /etc/automysqlbackup/automysqlbackup.conf
sed -i "s/MAXATTSIZE_PLACEHOLDER/$MAXATTSIZE/g" /etc/automysqlbackup/automysqlbackup.conf
sed -i "s/MAILADDR_PLACEHOLDER/$MAILADDR/g" /etc/automysqlbackup/automysqlbackup.conf

/usr/local/bin/automysqlbackup.sh
#sed -i "s/_PLACEHOLDER/$/g" /etc/automysqlbackup/automysqlbackup.conf

