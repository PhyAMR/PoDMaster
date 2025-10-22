#!/bin/bash

# Find all .git directories and loop through their parent directories
find . -name ".git" -type d -prune | while read -r gitdir; do
    repo_path=$(dirname "$gitdir")
    echo "Processing repository: $repo_path"
    
    # Change into the repository directory
    cd "$repo_path" || continue
    
    # Add all changes
    git add .
    
    # Commit with a standard message
    git commit -m "General update"
    
    # Push to the default remote
    git push
    
    # Go back to the original directory
    cd - > /dev/null
done

echo "All repositories have been processed."
