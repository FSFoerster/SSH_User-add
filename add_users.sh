#!/usr/bin/env bash

# +----- Variables ---------------------------------------------------------+

USER_FILE="./users"

# +----- Functions ---------------------------------------------------------+

add_users() {
    # Loop through the file.
    while read line; do
        # Split the line into the username and SSH key
        IFS=' ' read -ra parts <<< "$line"
        username="${parts[0]}"
        ssh_key="${parts[1]}"+"${parts[2]}"

        # Create the user if they don't already exist
        echo "Creating user $username"
        id -u "$username" &>/dev/null || useradd -m "$username"

        # Create the SSH directory and authorized_keys file
        echo "Creating SSH directory and authorized_keys file for user $username"
        su - "$username" -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

        # Add the SSH key to the authorized_keys file
        echo "Adding SSH key to the authorized_keys file for user $username"
        echo "$ssh_key" | su - "$username" -c "cat >> ~/.ssh/authorized_keys"
    done < "$USER_FILE"
}

# +----- Main --------------------------------------------------------------+

add_users
