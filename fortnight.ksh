#!/bin/bash

# Define the source folder where the .pgp files are located
SRC_FOLDER="/home/rahmasy/Public/scripts"

# Define the base path where the backup folders will be created
BASE_PATH="/home/rahmasy/Public/scripts"

# Path to a file that stores the last run date
LAST_RUN_FILE="/home/rahmasy/Public/scripts/last_run_date.txt"

# Initialize the last run file if it doesn't exist
if [ ! -f "$LAST_RUN_FILE" ]; then
    echo "1970-01-01" > "$LAST_RUN_FILE"
fi

# Read the last run date
last_run=$(cat "$LAST_RUN_FILE")

# Get the current date and day of the week
current_date=$(date +%Y-%m-%d)
current_day=$(date +%u) # %u gives the day of week (1..7); 1 is Monday and 7 is Sunday

# Calculate the number of days since the last run
days_since_last_run=$(( ($(date -d "$current_date" +%s) - $(date -d "$last_run" +%s)) / 86400 ))

# Check if today is Thursday (4) and it's 14 days since the last run
if [ "$current_day" -eq 6] && [ "$days_since_last_run" -ge 14 ]; then
    # Create the backup folder with naming convention backup_dd_month_yyyy
    DATE_STR=$(date +%d_%B_%Y)
    BACKUP_FOLDER="$BASE_PATH/backup_$DATE_STR"
    mkdir -p "$BACKUP_FOLDER"

    # Move all .pgp files from SRC_FOLDER to BACKUP_FOLDER
    for FILE in "$SRC_FOLDER"/*.pgp; do
      if [ -f "$FILE" ]; then
        mv "$FILE" "$BACKUP_FOLDER"
        echo "Moved: $FILE to $BACKUP_FOLDER"
      fi
    done

    # Update the last run date
    echo "$current_date" > "$LAST_RUN_FILE"
else
    # Skip running the script
    echo "Skipping fort.sh on $current_date (last run was $last_run)"
fi
