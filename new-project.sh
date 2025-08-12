#!/bin/bash
# Creates a new project with context

if [ -z "$1" ]; then
    echo "Usage: ./new-project.sh <project-name>"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR="/home/claude/projects/$PROJECT_NAME"

# Create project directory
mkdir -p "$PROJECT_DIR"

# Copy and customize template
cp /home/claude/templates/PROJECT_CONTEXT.md "$PROJECT_DIR/"
sed -i "s/\[PROJECT_NAME\]/$PROJECT_NAME/g" "$PROJECT_DIR/PROJECT_CONTEXT.md"

# Initialize git
cd "$PROJECT_DIR"
git init
echo "# $PROJECT_NAME" > README.md
echo "node_modules/" > .gitignore
echo ".env" >> .gitignore

# Update main context
echo "" >> /home/claude/CONTEXT.md
echo "### Project: $PROJECT_NAME" >> /home/claude/CONTEXT.md
echo "- **Status**: Planning" >> /home/claude/CONTEXT.md
echo "- **Context File**: \`/home/claude/projects/$PROJECT_NAME/PROJECT_CONTEXT.md\`" >> /home/claude/CONTEXT.md
echo "- **Last Updated**: $(date +%Y-%m-%d)" >> /home/claude/CONTEXT.md
echo "- **Priority**: Medium" >> /home/claude/CONTEXT.md

echo "✅ Project '$PROJECT_NAME' created at $PROJECT_DIR"
echo "📝 Edit $PROJECT_DIR/PROJECT_CONTEXT.md to add details"
