#!/bin/bash

sa_dir=$(pwd)"/service_accounts"                                # Directory containing the service accounts
currend_gdsa_file=$(pwd)"/current_gdsa"                         # File to keep track of last used service account
local_dir="/mnt/gmedia-local"                                   # Directory containing files to upload
rclone_config="/root/.config/rclone/rclone.conf"           # rclone config file
rclone_mount_name="gdrive-crypt:"                               # rclone mount name
log_file="/opt/rclone/logs/upload.log"                          # rclone upload logfile

# Get the number of files in the directory
num_files=$(ls "$sa_dir" | wc -l)

# Set the starting file number
gdsa_index=1

# Check if our tracking file exists
if [ ! -f $currend_gdsa_file ]; then
    # If the file doesn't exist, create it and set the service account index to 1
    echo 1 > $currend_gdsa_file
else
    # If the file exists, read the service account index from it
    gdsa_index=$(cat $currend_gdsa_file)
fi

/usr/bin/rclone move $local_dir $rclone_mount \
    --config $rclone_config \
    --log-file $log_file \
    --log-level INFO \
    --delete-empty-src-dirs \
    --fast-list \
    --min-age 30m \
    --drive-stop-on-upload-limit \
    --drive-service-account-file="$sa_dir/$gdsa_index.json" \
    --error-on-no-transfer

# Increment the service account index
gdsa_index=$((gdsa_index+1))

# If the next service account index is greater than the number of files, set it back to 1
if [[ $gdsa_index -gt $num_files ]]; then
    gdsa_index=1
fi

# Update the tracking file with the new current file number
echo $gdsa_index > $currend_gdsa_file
