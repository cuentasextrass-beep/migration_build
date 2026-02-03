#!/bin/bash

# Define target directory for symlinks
TARGET_DIR="$HOME/.local/bin"

# Ensure target directory exists
#mkdir -p "$TARGET_DIR"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Iterate over files in the script directory
for file in "$SCRIPT_DIR"/*; do
    # Skip if it's this script itself
    if [[ "$file" == "$SCRIPT_DIR/$(basename "$0")" ]]; then
        continue
    fi

    # Skip if it's not a regular file
    [[ -f "$file" ]] || continue

    # Get the filename
    filename=$(basename "$file")
    symlink_path="$TARGET_DIR/$filename"

    # Check if symlink or file already exists in target
    if [[ -e "$symlink_path" || -L "$symlink_path" ]]; then
        while true; do
            read -p "Symlink $symlink_path already exists. Overwrite? (y/n): " choice
            case "$choice" in
                y|Y ) rm -f "$symlink_path"; break ;;
                n|N ) echo "Skipping $filename"; continue 2 ;;
                * ) echo "Please enter y or n." ;;
            esac
        done
    fi

    # Create symlink in ~/.local/bin
    ln -s "$file" "$symlink_path"

    # Make sure the symlink is executable
    chmod +x "$symlink_path"
    
    echo "Linked: $filename -> $symlink_path"
done

echo "All scripts linked successfully!"

