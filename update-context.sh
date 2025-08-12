#!/bin/bash
# Updates timestamps in context files

CONTEXT_FILE="/home/claude/CONTEXT.md"
DATE=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Update last modified
sed -i "s/\*Last Modified: .*/\*Last Modified: $TIMESTAMP*/" $CONTEXT_FILE

# Increment session count
current_count=$(grep "Session Count:" $CONTEXT_FILE | sed 's/.*Session Count: //' | sed 's/\*//')
new_count=$((current_count + 1))
sed -i "s/\*Session Count: .*/\*Session Count: $new_count*/" $CONTEXT_FILE

echo "✅ Context updated - Session #$new_count at $TIMESTAMP"
