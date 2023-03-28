#!/bin/zsh
# This script removes illegal characters for OneDrive work or school accounts from folder and file names
# It also removes leading and trailing whitespace from folder and file names
# The original folder and file names are kept

# Set the field separator to newline to handle spaces in file/folder names
IFS=$'\n'

# Define a function to remove illegal characters and trim leading/trailing whitespace
function sanitize_name() {
    local name="$1"
    # Remove illegal characters
    name="${name//[\:#%&\*?\"<>|\/\\{\}~]/}"
    # Remove leading/trailing whitespace
    name="$(echo "$name" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    echo "$name"
}
# Find all directories and files in the current directory and its subdirectories
for item in $(find . -depth); do
    # Get the base name of the item (file or folder)
    base_name="$(basename "$item")"
    # Sanitize the base name
    new_name="$(sanitize_name "$base_name")"
    # If the new name is different from the original name, rename the item
    if [[ "$new_name" != "$base_name" ]]; then
        mv -i "$item" "$(dirname "$item")/$new_name"
    fi
done

unset IFS