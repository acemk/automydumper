#!/usr/bin/env bash
#
# MySQL MyDumper Backup Script
# VER. 2.5.1 - http://sourceforge.net/projects/automysqlbackup/
# VER. 2.6.0 - https://github.com/tyzhnenko/AutoMySQLBackup-mydumper
# Copyright (c) 2002-2003 wipe_out@lycos.co.uk
# Copyright (c) 2013 Tyzhnenko Dmitry t.dmitry@gmail.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#=====================================================================
#=====================================================================
# Set the following variables to your system needs
# (Detailed instructions below variables)
#=====================================================================
#set -x

# Use environment variables
# USERNAME - Username to access the MySQL server e.g. dbuser
# PASSWORD - Password to access the MySQL server e.g. password
# DBHOST - Host name (or IP address) of MySQL server e.g localhost
# DBNAMES="all" - List of DBNAMES for Daily/Weekly Backup e.g. "DB1 DB2 DB3"

# Backup directory location e.g /backups
BACKUPDIR="/srv/backup/db"

# Mail setup
# What would you like to be mailed to you?
# - log   : send only log file
# - files : send log file and sql files as attachments (see docs)
# - stdout : will simply output the log to the screen if run manually.
# - quiet : Only send logs if an error occurs to the MAILADDR.
# MAILCONTENT="log"

# MAXATTSIZE - Set the maximum allowed email size in k. (4000 = approx 5MB email [see docs])


# MAILADDR - Email Address to send mail to? (user@domain.com)


# ============================================================
# === ADVANCED OPTIONS ( Read the doc's below for details )===
#=============================================================

# List of DBBNAMES for Monthly Backups.
MDBNAMES="${DBNAMES}"

# List of DBNAMES to EXLUCDE if DBNAMES are set to all (must be in " quotes)
DBEXCLUDE=""

# Include CREATE DATABASE in backup?
CREATE_DATABASE=no

# Separate backup directory and file for each DB? (yes or no)
SEPDIR=yes

# Which day do you want weekly backups? (1 to 7 where 1 is Monday)
DOWEEKLY=6

# Choose Compression type. (gzip or bzip2)
COMP=gzip

# Compress communications between backup server and MySQL server?
COMMCOMP=no

# Additionally keep a copy of the most recent backup in a seperate directory.
LATEST=no

#  The maximum size of the buffer for client/server communication. e.g. 16MB (maximum is 1GB)
MAX_ALLOWED_PACKET=

#  For connections to localhost. Sometimes the Unix socket file must be specified.
SOCKET=

# Use mydumper istead of mysqldump. Used only when SEPDIR=yes
MYDUMPER_USE='yes'

MYDUMPER_COMPRESS='yes'

MYDUMPER_NO_LOCKS='yes'

MYDUMPER_THREADS=4

# Set umask
# Uncomment to activate! This will give folders rwx------
# and files rw------- permissions.
SET_UMASK=0077

# Set rotation of daily backups. VALUE*24hours
# ROTATION_DAILY=6 - If you want to keep only today's backups, you could choose 1, i.e. everything older than 24hours will be removed.
# ROTATION_WEEKLY=35 - Set rotation for weekly backups. VALUE*24hours
# ROTATION_MONTHLY=150 - Set rotation for monthly backups. VALUE*24hours


# Command to run before backups (uncomment to use)
#PREBACKUP="/etc/mysql-backup-pre"

# Command run after backups (uncomment to use)
#POSTBACKUP="/etc/mysql-backup-post"


#=====================================================================
# Options documantation
#=====================================================================
# Set USERNAME and PASSWORD of a user that has the appropriate permissions
# to backup ALL databases. (See mysql documentation for details)
# NEW in 2.5.1:
# - If USERNAME is set to "debian" and PASSWORD is unset or "" obtain
#   them from the file /etc/mysql/debian.cnf
# - First command line option "-c" for configfile
# - Interpretable Exit-States:
#    1: given configfile is not readable or does not exist
#    2: unknown option
#
# Set the DBHOST option to the server you wish to backup, leave the
# default to backup "this server".(to backup multiple servers make
# copies of this file and set the options for that server)
#
# Put in the list of DBNAMES(Databases)to be backed up. If you would like
# to backup ALL DBs on the server set DBNAMES="all".(if set to "all" then
# any new DBs will automatically be backed up without needing to modify
# this backup script when a new DB is created).
#
# If the DB you want to backup has a space in the name replace the space
# with a % e.g. "data base" will become "data%base"
# NOTE: Spaces in DB names may not work correctly when SEPDIR=no.
#
# You can change the backup storage location from /backups to anything
# you like by using the BACKUPDIR setting..
#
# The MAILCONTENT and MAILADDR options and pretty self explanitory, use
# these to have the backup log mailed to you at any email address or multiple
# email addresses in a space seperated list.
# (If you set mail content to "log" you will require access to the "mail" program
# on your server. If you set this to "files" you will have to have mutt installed
# on your server. If you set it to "stdout" it will log to the screen if run from
# the console or to the cron job owner if run through cron. If you set it to "quiet"
# logs will only be mailed if there are errors reported. )
#
# MAXATTSIZE sets the largest allowed email attachments total (all backup files) you
# want the script to send. This is the size before it is encoded to be sent as an email
# so if your mail server will allow a maximum mail size of 5MB I would suggest setting
# MAXATTSIZE to be 25% smaller than that so a setting of 4000 would probably be fine.
#
# Finally copy automysqlbackup.sh to anywhere on your server and make sure
# to set executable permission. You can also copy the script to
# /etc/cron.daily to have it execute automatically every night or simply
# place a symlink in /etc/cron.daily to the file if you wish to keep it
# somwhere else.
# NOTE:On Debian copy the file with no extention for it to be run
# by cron e.g just name the file "automysqlbackup"
#
# Thats it..
#
#
# === Advanced options doc's ===
#
# The list of MDBNAMES is the DB's to be backed up only monthly. You should
# always include "mysql" in this list to backup your user/password
# information along with any other DBs that you only feel need to
# be backed up monthly. (if using a hosted server then you should
# probably remove "mysql" as your provider will be backing this up)
# NOTE: If DBNAMES="all" then MDBNAMES has no effect as all DBs will be backed
# up anyway.
#
# If you set DBNAMES="all" you can configure the option DBEXCLUDE. Other
# wise this option will not be used.
# This option can be used if you want to backup all dbs, but you want
# exclude some of them. (eg. a db is to big).
#
# Set CREATE_DATABASE to "yes" (the default) if you want your SQL-Dump to create
# a database with the same name as the original database when restoring.
# Saying "no" here will allow your to specify the database name you want to
# restore your dump into, making a copy of the database by using the dump
# created with automysqlbackup.
# NOTE: Not used if SEPDIR=no
#
# The SEPDIR option allows you to choose to have all DBs backed up to
# a single file (fast restore of entire server in case of crash) or to
# seperate directories for each DB (each DB can be restored seperately
# in case of single DB corruption or loss).
#
# To set the day of the week that you would like the weekly backup to happen
# set the DOWEEKLY setting, this can be a value from 1 to 7 where 1 is Monday,
# The default is 6 which means that weekly backups are done on a Saturday.
#
# COMP is used to choose the copmression used, options are gzip or bzip2.
# bzip2 will produce slightly smaller files but is more processor intensive so
# may take longer to complete.
#
# COMMCOMP is used to enable or diable mysql client to server compression, so
# it is useful to save bandwidth when backing up a remote MySQL server over
# the network.
#
# LATEST is to store an additional copy of the latest backup to a standard
# location so it can be downloaded bt thrid party scripts.
#
# If the DB's being backed up make use of large BLOB fields then you may need
# to increase the MAX_ALLOWED_PACKET setting, for example 16MB..
#
# When connecting to localhost as the DB server (DBHOST=localhost) sometimes
# the system can have issues locating the socket file.. This can now be set
# using the SOCKET parameter.. An example may be SOCKET=/private/tmp/mysql.sock
#
# Use PREBACKUP and POSTBACKUP to specify Per and Post backup commands
# or scripts to perform tasks either before or after the backup process.
#
#
#=====================================================================
# Backup Rotation..
#=====================================================================
#
# Daily Backups are rotated weekly..
# Weekly Backups are run by default on Saturday Morning when
# cron.daily scripts are run...Can be changed with DOWEEKLY setting..
# Weekly Backups are rotated on a 5 week cycle..
# Monthly Backups are run on the 1st of the month..
# Monthly Backups are rotated on a 5 month cycle...
# It may be a good idea to copy Monthly backups offline or to another
# server..
#
#=====================================================================
# Please Note!!
#=====================================================================
#
# I take no resposibility for any data loss or corruption when using
# this script..
# This script will not help in the event of a hard drive crash. If a
# copy of the backup has not be stored offline or on another PC..
# You should copy your backups offline regularly for best protection.
#
# Happy backing up...
#
#=====================================================================
# Restoring
#=====================================================================
# Firstly you will need to uncompress the backup file.
# eg.
# gunzip file.gz (or bunzip2 file.bz2)
#
# Next you will need to use the mysql client to restore the DB from the
# sql file.
# eg.
# mysql --user=username --pass=password --host=dbserver database < /path/file.sql
# or
# mysql --user=username --pass=password --host=dbserver -e "source /path/file.sql" database
#
# NOTE: Make sure you use "<" and not ">" in the above command because
# you are piping the file.sql to mysql and not the other way around.
#
# Lets hope you never have to use this.. :)
#
#=====================================================================
#=====================================================================
#=====================================================================
#
# Should not need to be modified from here down!!
#
#=====================================================================
#=====================================================================
#=====================================================================
#
# Full pathname to binaries to avoid problems with aliases and builtins etc.
#
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/mysql/bin
WHICH="`which which`"
AWK="`${WHICH} gawk`"
LOGGER="`${WHICH} logger`"
ECHO="`${WHICH} echo`"
CAT="`${WHICH} cat`"
BASENAME="`${WHICH} basename`"
DATEC="`${WHICH} date`"
DU="`${WHICH} du`"
EXPR="`${WHICH} expr`"
FIND="`${WHICH} find`"
RM="`${WHICH} rm`"
MYSQL="`${WHICH} mysql`"
MYSQLDUMP="`${WHICH} mysqldump`"
MYDUMPER="`${WHICH} mydumper`"
GZIP="`${WHICH} gzip`"
BZIP2="`${WHICH} bzip2`"
CP="`${WHICH} cp`"
HOSTNAMEC="`${WHICH} hostname`"
SED="`${WHICH} sed`"
GREP="`${WHICH} grep`"
UMASK="umask"

function get_debian_pw() {
	if [ -r /etc/mysql/debian.cnf ]; then
		eval $(${AWK} '
			! user && /^[[:space:]]*user[[:space:]]*=[[:space:]]*/ {
				print "USERNAME=" gensub(/.+[[:space:]]+([^[:space:]]+)[[:space:]]*$/, "\\1", "1"); user++
			}
			! pass && /^[[:space:]]*password[[:space:]]*=[[:space:]]*/ {
				print "PASSWORD=" gensub(/.+[[:space:]]+([^[:space:]]+)[[:space:]]*$/, "\\1", "1"); pass++
			}' /etc/mysql/debian.cnf
		)
	else
		${LOGGER} "${PROGNAME}: File \"/etc/mysql/debian.cnf\" not found."
		exit 1
	fi
}

[ "x${USERNAME}" = "xdebian" -a "x${PASSWORD}" = "x" ] && get_debian_pw

while [ $# -gt 0 ]; do
	case $1 in
		-c)
			if [ -r "$2" ]; then
				source "$2"
				shift 2
			else
				${ECHO} "Ureadable config file \"$2\""
				exit 1
			fi
			;;
		*)
			${ECHO} "Unknown Option \"$1\""
			exit 2
			;;
	esac
done

export LC_ALL=C
PROGNAME=`${BASENAME} $0`
DATE=`${DATEC} +%Y-%m-%d_%Hh%Mm`				# Datestamp e.g 2002-09-21_13h55m
DOW=`${DATEC} +%A`							# Day of the week e.g. Monday
DNOW=`${DATEC} +%u`						# Day number of the week 1 to 7 where 1 represents Monday
DOM=`${DATEC} +%d`							# Date of the Month e.g. 27
M=`${DATEC} +%B`							# Month e.g January
W=`${DATEC} +%V`							# Week Number e.g 37
VER=2.6.1									# Version Number
LOGFILE=${BACKUPDIR}/${DBHOST}-${DATE}.log		# Logfile Name
LOGERR=${BACKUPDIR}/ERRORS_${DBHOST}-${DATE}.log		# Logfile Name
BACKUPFILES=""
OPT="--quote-names --opt"			# OPT string for use with mysqldump ( see man mysqldump )
MYDUMPER_OPT=''


# IO redirection for logging.
touch ${LOGFILE}
exec 6>&1           # Link file descriptor #6 with stdout.
                    # Saves stdout.
exec > ${LOGFILE}     # stdout replaced with file ${LOGFILE}.
touch ${LOGERR}
exec 7>&2           # Link file descriptor #7 with stderr.
                    # Saves stderr.
exec 2> ${LOGERR}     # stderr replaced with file ${LOGERR}.

# Add --compress mysqldump option to ${OPT}
if [ "${COMMCOMP}" = "yes" ];
	then
		OPT="${OPT} --compress"
	fi

# Add --max_allowed_packet=... mysqldump option to ${OPT}
if [ "${MAX_ALLOWED_PACKET}" ];
	then
		OPT="${OPT} --max_allowed_packet=${MAX_ALLOWED_PACKET}"
	fi

if [ "$MYDUMPER_COMPRESS" = 'yes' ]; then
    MYDUMPER_OPT="$MYDUMPER_OPT --compress"
fi

if [ "$MYDUMPER_NO_LOCKS" = 'yes' ]; then
    MYDUMPER_OPT="$MYDUMPER_OPT --no-locks"
fi

if [ "$MYDUMPER_THREADS" -gt '0' ]; then
    MYDUMPER_OPT="$MYDUMPER_OPT --threads $MYDUMPER_THREADS"
fi

# Create required directories
if [ ! -e "${BACKUPDIR}" ]		# Check Backup Directory exists.
	then
	mkdir -p "${BACKUPDIR}"
fi

if [ ! -e "${BACKUPDIR}/daily" ]		# Check Daily Directory exists.
	then
	mkdir -p "${BACKUPDIR}/daily"
fi

if [ ! -e "${BACKUPDIR}/weekly" ]		# Check Weekly Directory exists.
	then
	mkdir -p "${BACKUPDIR}/weekly"
fi

if [ ! -e "${BACKUPDIR}/monthly" ]	# Check Monthly Directory exists.
	then
	mkdir -p "${BACKUPDIR}/monthly"
fi

if [ "${LATEST}" = "yes" ]
then
	if [ ! -e "${BACKUPDIR}/latest" ]	# Check Latest Directory exists.
	then
		mkdir -p "${BACKUPDIR}/latest"
	fi
eval ${RM} -fv "${BACKUPDIR}/latest/*"
fi


# Functions

# Database dump function
dbdump () {
    if [ "$MYDUMPER_USE" = 'yes' ]; then
        ${MYDUMPER} --user=${USERNAME} --password="${PASSWORD}" --host=${DBHOST} ${MYDUMPER_OPT} --database ${1} --outputdir ${2}
    else
        ${MYSQLDUMP} --user=${USERNAME} --password="${PASSWORD}" --host=${DBHOST} ${OPT} ${1} > ${2}
    fi
return $?
}

# Compression function plus latest copy
SUFFIX=""
compression () {
if [ "${COMP}" = "gzip" ]; then
	${GZIP} -f "${1}"
	${ECHO}
	${ECHO} "Backup Information for \"${1}\""
	${GZIP} -l "${1}.gz"
	SUFFIX=".gz"
elif [ "${COMP}" = "bzip2" ]; then
	${ECHO} "Compression information for \"${1}.bz2\""
	${BZIP2} -f -v ${1} 2>&1
	SUFFIX=".bz2"
else
	${ECHO} "No compression option set, check advanced settings"
fi
if [ "${LATEST}" = "yes" ]; then
	${CP} -avl ${1}${SUFFIX} "${BACKUPDIR}/latest/"
fi
return 0
}


# Run command before we begin
if [ "${PREBACKUP}" ]
	then
	${ECHO} "======================================================================"
	${ECHO} "Prebackup command output."
	${ECHO}
	eval ${PREBACKUP}
	${ECHO}
	${ECHO} "======================================================================"
	${ECHO}
fi


if [ "${SEPDIR}" = "yes" ]; then # Check if CREATE DATABSE should be included in Dump
	if [ "${CREATE_DATABASE}" = "no" ]; then
		OPT="${OPT} --no-create-db"
	else
		OPT="${OPT} --databases"
	fi
else
	OPT="${OPT} --databases"
fi

# Hostname for LOG information
if [ "${DBHOST}" = "localhost" ]; then
	HOST=`${HOSTNAMEC}`
	if [ "${SOCKET}" ]; then
		OPT="${OPT} --socket=${SOCKET}"
	fi
else
	HOST=${DBHOST}
fi

# If backing up all DBs on the server
if [ "${DBNAMES}" = "all" ]; then
        DBNAMES="`${MYSQL} --user=${USERNAME} --password="${PASSWORD}" --host=${DBHOST} --batch --skip-column-names -e "show databases"| ${SED} 's/ /%/g'`"

	# If DBs are excluded
	for exclude in ${DBEXCLUDE}
	do
		DBNAMES=`${ECHO} ${DBNAMES} | ${SED} "s/\b${exclude}\b//g"`
	done

        MDBNAMES=${DBNAMES}
fi

${ECHO} "======================================================================"
${ECHO} "AutoMySQLBackup VER ${VER}"
${ECHO} "http://sourceforge.net/projects/automysqlbackup/"
${ECHO}
${ECHO} "Backup of Database Server - ${HOST}"
${ECHO} "======================================================================"
${ECHO}
${ECHO} "Set umask to ${SET_UMASK}"
${UMASK} ${SET_UMASK}
# Test is seperate DB backups are required
if [ "${SEPDIR}" = "yes" ]; then
${ECHO} "Backup Start Time `${DATEC}`"
${ECHO} "======================================================================"
	# Monthly Full Backup of all Databases
	if [ ${DOM} = "01" ]; then
		for MDB in ${MDBNAMES}
		do

			 # Prepare ${DB} for using
		        MDB="`${ECHO} ${MDB} | ${SED} 's/%/ /g'`"

			if [ ! -e "${BACKUPDIR}/monthly/${MDB}" ]		# Check Monthly DB Directory exists.
			then
				mkdir -p "${BACKUPDIR}/monthly/${MDB}"
			fi
			${ECHO} "Monthly Backup of ${MDB}..."
                if [ "$MYDUMPER_USE" = 'yes' ]; then
                    if [ ! -e "${BACKUPDIR}/monthly/${MDB}/${MDB}_${DATE}.${M}.${MDB}" ]       # Check Database backup directory exists.
                    then
                        mkdir -p "${BACKUPDIR}/monthly/${MDB}/${MDB}_${DATE}.${M}.${MDB}"
                    fi
				    dbdump "${MDB}" "${BACKUPDIR}/monthly/${MDB}/${MDB}_${DATE}.${M}.${MDB}"
                else
                    dbdump "${MDB}" "${BACKUPDIR}/monthly/${MDB}/${MDB}_${DATE}.${M}.${MDB}.sql"
                fi
				[ $? -eq 0 ] && {
					${ECHO} "Rotating 5 month backups for ${MDB}"
					${FIND} "${BACKUPDIR}/monthly/${MDB}" -mtime +${ROTATION_MONTHLY} -type f -exec ${RM} -v {} \;
				}
                if [ "$MYDUMPER_USE" = 'yes' ]; then
				    BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/monthly/${MDB}/${MDB}_${DATE}.${M}.${MDB}"
                else
                    compression "${BACKUPDIR}/monthly/${MDB}/${MDB}_${DATE}.${M}.${MDB}.sql"
                    BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/monthly/${MDB}/${MDB}_${DATE}.${M}.${MDB}.sql${SUFFIX}"
                fi
			${ECHO} "----------------------------------------------------------------------"
		done
	fi

	for DB in ${DBNAMES}
	do
	# Prepare ${DB} for using
	DB="`${ECHO} ${DB} | ${SED} 's/%/ /g'`"

	# Create Seperate directory for each DB
	if [ ! -e "${BACKUPDIR}/daily/${DB}" ]		# Check Daily DB Directory exists.
		then
		mkdir -p "${BACKUPDIR}/daily/${DB}"
	fi

	if [ ! -e "${BACKUPDIR}/weekly/${DB}" ]		# Check Weekly DB Directory exists.
		then
		mkdir -p "${BACKUPDIR}/weekly/${DB}"
	fi

	# Weekly Backup
	if [ ${DNOW} = ${DOWEEKLY} ]; then
		${ECHO} "Weekly Backup of Database ( ${DB} )"
		${ECHO}
            if [ "$MYDUMPER_USE" = 'yes' ]; then
                if [ ! -e "${BACKUPDIR}/weekly/${DB}/${DB}_week.${W}.${DATE}" ]       # Check Database backup directory exists.
                then
                    mkdir -p "${BACKUPDIR}/weekly/${DB}/${DB}_week.${W}.${DATE}"
                fi
			    dbdump "${DB}" "${BACKUPDIR}/weekly/${DB}/${DB}_week.${W}.${DATE}"
            else
                dbdump "${DB}" "${BACKUPDIR}/weekly/${DB}/${DB}_week.${W}.${DATE}.sql"
            fi
			[ $? -eq 0 ] && {
				${ECHO} "Rotating 5 weeks Backups..."
				${FIND} "${BACKUPDIR}/weekly/${DB}" -mtime +${ROTATION_WEEKLY} -type f -exec ${RM} -v {} \;
			}
            if [ "$MYDUMPER_USE" = 'yes' ]; then
			    BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/weekly/${DB}/${DB}_week.${W}.${DATE}"
            else
                compression "${BACKUPDIR}/weekly/${DB}/${DB}_week.${W}.${DATE}.sql"
                BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/weekly/${DB}/${DB}_week.${W}.${DATE}.sql${SUFFIX}"
            fi
		${ECHO} "----------------------------------------------------------------------"

	# Daily Backup
	else
		${ECHO} "Daily Backup of Database ( ${DB} )"
		${ECHO}
            if [ "$MYDUMPER_USE" = 'yes' ]; then
                if [ ! -e "${BACKUPDIR}/daily/${DB}/${DB}_${DATE}.${DOW}" ]       # Check Database backup directory exists.
                then
                    mkdir -p "${BACKUPDIR}/daily/${DB}/${DB}_${DATE}.${DOW}"
                fi
			    dbdump "${DB}" "${BACKUPDIR}/daily/${DB}/${DB}_${DATE}.${DOW}"
            else
                dbdump "${DB}" "${BACKUPDIR}/daily/${DB}/${DB}_${DATE}.${DOW}.sql"
            fi
			[ $? -eq 0 ] && {
				${ECHO} "Rotating last weeks Backup..."
				${FIND} "${BACKUPDIR}/daily/${DB}" -mtime +${ROTATION_DAILY} -type f -exec ${RM} -v {} \;
			}
            if [ "$MYDUMPER_USE" = 'yes' ]; then
			    BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/daily/${DB}/${DB}_${DATE}.${DOW}"
            else
                compression "${BACKUPDIR}/daily/${DB}/${DB}_${DATE}.${DOW}.sql"
                BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/daily/${DB}/${DB}_${DATE}.${DOW}.sql${SUFFIX}"
            fi
		${ECHO} "----------------------------------------------------------------------"
	fi
	done
${ECHO} "Backup End `${DATEC}`"
${ECHO} "======================================================================"


else # One backup file for all DBs
${ECHO} "Backup Start `${DATEC}`"
${ECHO} "======================================================================"
	# Monthly Full Backup of all Databases
	if [ ${DOM} = "01" ]; then
		${ECHO} "Monthly full Backup of ( ${MDBNAMES} )..."
			dbdump "${MDBNAMES}" "${BACKUPDIR}/monthly/${DATE}.${M}.all-databases.sql"
			[ $? -eq 0 ] && {
				${ECHO} "Rotating 5 month backups."
				${FIND} "${BACKUPDIR}/monthly" -mtime +150 -type f -exec ${RM} -v {} \;
			}
			compression "${BACKUPDIR}/monthly/${DATE}.${M}.all-databases.sql"
			BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/monthly/${DATE}.${M}.all-databases.sql${SUFFIX}"
		${ECHO} "----------------------------------------------------------------------"
	fi

	# Weekly Backup
	if [ ${DNOW} = ${DOWEEKLY} ]; then
		${ECHO} "Weekly Backup of Databases ( ${DBNAMES} )"
		${ECHO}
		${ECHO}
			dbdump "${DBNAMES}" "${BACKUPDIR}/weekly/week.${W}.${DATE}.sql"
			[ $? -eq 0 ] && {
				${ECHO} Rotating 5 weeks Backups...
				${FIND} "${BACKUPDIR}/weekly/" -mtime +35 -type f -exec ${RM} -v {} \;
			}
			compression "${BACKUPDIR}/weekly/week.${W}.${DATE}.sql"
			BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/weekly/week.${W}.${DATE}.sql${SUFFIX}"
		${ECHO} "----------------------------------------------------------------------"

	# Daily Backup
	else
		${ECHO} "Daily Backup of Databases ( ${DBNAMES} )"
		${ECHO}
		${ECHO}
			dbdump "${DBNAMES}" "${BACKUPDIR}/daily/${DATE}.${DOW}.sql"
			[ $? -eq 0 ] && {
				${ECHO} Rotating last weeks Backup...
				${FIND} "${BACKUPDIR}/daily" -mtime +6 -type f -exec ${RM} -v {} \;
			}
			compression "${BACKUPDIR}/daily/${DATE}.${DOW}.sql"
			BACKUPFILES="${BACKUPFILES} ${BACKUPDIR}/daily/${DATE}.${DOW}.sql${SUFFIX}"
		${ECHO} "----------------------------------------------------------------------"
	fi
${ECHO} "Backup End Time `${DATEC}`"
${ECHO} "======================================================================"
fi
${ECHO} "Total disk space used for backup storage..."
${ECHO} "Size - Location"
${ECHO} "`${DU} -hsD "${BACKUPDIR}"`"
${ECHO}
${ECHO} "======================================================================"
${ECHO} "If you find AutoMySQLBackup valuable please make a donation at"
${ECHO} "http://sourceforge.net/project/project_donations.php?group_id=101066"
${ECHO} "======================================================================"

# Run command when we're done
if [ "${POSTBACKUP}" ]
	then
	${ECHO} "======================================================================"
	${ECHO} "Postbackup command output."
	${ECHO}
	eval ${POSTBACKUP}
	${ECHO}
	${ECHO} "======================================================================"
fi

#Clean up IO redirection
exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
exec 2>&7 7>&-      # Restore stdout and close file descriptor #7.

if [ "${MAILCONTENT}" = "files" ]
then
	if [ -s "${LOGERR}" ]
	then
		# Include error log if is larger than zero.
		BACKUPFILES="${BACKUPFILES} ${LOGERR}"
		ERRORNOTE="WARNING: Error Reported - "
	fi
	#Get backup size
	ATTSIZE=`${DU} -c ${BACKUPFILES} | ${GREP} "[[:digit:][:space:]]total$" |${SED} s/\s*total//`
	if [ ${MAXATTSIZE} -ge ${ATTSIZE} ]
	then
		BACKUPFILES=`${ECHO} "${BACKUPFILES}" | ${SED} -e "s# # -a #g"`	#enable multiple attachments
		mutt -s "${ERRORNOTE} MySQL Backup Log and SQL Files for ${HOST} - ${DATE}" ${BACKUPFILES} ${MAILADDR} < ${LOGFILE}		#send via mutt
	else
		${CAT} "${LOGFILE}" | mail -s "WARNING! - MySQL Backup exceeds set maximum attachment size on ${HOST} - ${DATE}" ${MAILADDR}
	fi
elif [ "${MAILCONTENT}" = "log" ]
then
	${CAT} "${LOGFILE}" | mail -s "MySQL Backup Log for ${HOST} - ${DATE}" ${MAILADDR}
	if [ -s "${LOGERR}" ]
		then
			${CAT} "${LOGERR}" | mail -s "ERRORS REPORTED: MySQL Backup error Log for ${HOST} - ${DATE}" ${MAILADDR}
	fi
elif [ "${MAILCONTENT}" = "quiet" ]
then
	if [ -s "${LOGERR}" ]
		then
			${CAT} "${LOGERR}" | mail -s "ERRORS REPORTED: MySQL Backup error Log for ${HOST} - ${DATE}" ${MAILADDR}
			${CAT} "${LOGFILE}" | mail -s "MySQL Backup Log for ${HOST} - ${DATE}" ${MAILADDR}
	fi
else
	if [ -s "${LOGERR}" ]
		then
			${CAT} "${LOGFILE}"
			${ECHO}
			${ECHO} "###### WARNING ######"
			${ECHO} "Errors reported during AutoMySQLBackup execution.. Backup failed"
			${ECHO} "Error log below.."
			${CAT} "${LOGERR}"
	else
		${CAT} "${LOGFILE}"
	fi
fi

if [ -s "${LOGERR}" ]
	then
		STATUS=1
	else
		STATUS=0
fi

# Clean up Logfile
#eval ${RM} -f "${LOGFILE}"
#eval ${RM} -f "${LOGERR}"

exit ${STATUS}
