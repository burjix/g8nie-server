#!/bin/bash

# Claude CTO Environment Initialization Script
# Run this once to set up the complete environment

set -e  # Exit on error

echo "🚀 Initializing Claude CTO Environment..."

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p /home/claude/{projects,workspace,sandbox,archive,logs/daily,knowledge,templates}
mkdir -p /home/claude/.config

# Create knowledge base files
echo "📚 Setting up knowledge base..."
cat > /home/claude/knowledge/solutions.md << 'EOF'
# Solutions Database
> Document solved problems and their solutions here

## Format for entries:
### Problem: [Brief description]
**Date**: YYYY-MM-DD  
**Project**: [Project name or general]  
**Tags**: #tag1 #tag2  

**Issue**: 
Detailed description of the problem

**Solution**:
```language
// Code or commands that solved it
```

**Explanation**: 
Why this works and when to use it

**Related**: 
Links to documentation or similar issues

---

## Solved Problems

<!-- Add entries below -->

EOF

cat > /home/claude/knowledge/fixes.md << 'EOF'
# Error Fixes & Debugging
> Common errors and their fixes

## Format for entries:
### Error: [Error message or type]
**Frequency**: Common/Rare  
**Contexts**: Where this appears  

**Full Error**:
```
Complete error message
```

**Fix**:
```bash
# Commands or code to fix
```

**Prevention**: 
How to avoid this error

---

## Fixed Errors

<!-- Add entries below -->

EOF

cat > /home/claude/knowledge/snippets.md << 'EOF'
# Code Snippets Library
> Reusable code blocks for common tasks

## Categories
- [Authentication](#authentication)
- [Database](#database)
- [API Patterns](#api-patterns)
- [Frontend Components](#frontend-components)
- [DevOps Scripts](#devops-scripts)
- [Utilities](#utilities)

---

## Authentication

## Database

## API Patterns

## Frontend Components
<!-- Remember: No generic AI-looking designs! -->

## DevOps Scripts

## Utilities

<!-- Add snippets in appropriate categories -->

EOF

cat > /home/claude/knowledge/patterns.md << 'EOF'
# Architecture Patterns
> Proven patterns for different scenarios

## Pattern Template:
### Pattern: [Name]
**Use Case**: When to use this  
**Benefits**: Why it's good  
**Drawbacks**: Limitations  
**Implementation**: High-level approach  
**Example Projects**: Where we've used this  

---

## Implemented Patterns

<!-- Add patterns below -->

### Pattern: Repository Pattern with Node.js
**Use Case**: When you need data source abstraction  
**Benefits**: Easy to test, swap databases, clean architecture  
**Implementation**: Repository class with interface methods  

EOF

cat > /home/claude/knowledge/optimizations.md << 'EOF'
# Performance Optimizations
> Optimization techniques that worked

## Categories
- [Backend](#backend)
- [Frontend](#frontend)  
- [Database](#database)
- [Infrastructure](#infrastructure)

---

## Backend

## Frontend
<!-- Remember: Performance AND unique design -->

## Database

## Infrastructure

<!-- Add optimizations with before/after metrics when possible -->

EOF

# Create project template
echo "📋 Creating project template..."
cat > /home/claude/templates/PROJECT_CONTEXT.md << 'EOF'
# Project: [PROJECT_NAME]

## Overview
- **Created**: $(date +%Y-%m-%d)
- **Type**: [Web App/API/Service/Tool/Full Stack]
- **Status**: Planning
- **Repository**: [GIT_URL]
- **Production URL**: [If deployed]
- **Development URL**: [Local URL]

## Technical Stack
- **Backend**: 
- **Frontend**: 
- **Database**: 
- **Authentication**: 
- **Hosting**: 
- **Other Services**: 

## Design Requirements
- **Style**: [Based on Skander's preferences - unique, not AI-looking]
- **Key Colors**: [Avoid generic blues]
- **Typography**: 
- **Special Notes**: No excessive gradients, minimal icons

## Current Sprint/Phase
### Goals
- [ ] Goal 1
- [ ] Goal 2

### Completed
- [x] Setup project structure

### In Progress
- Working on: 

### Blockers
- None currently

## Architecture Decisions

### Decision 1: [Title]
**Date**: YYYY-MM-DD
**Context**: What we needed to solve
**Decision**: What we chose
**Reasoning**: Why this approach
**Alternatives Considered**: Other options

## API Endpoints (if applicable)
| Method | Endpoint | Description | Status |
|--------|----------|-------------|--------|
| GET    | /api/... | Description | ✅/🚧/❌ |

## Environment Variables
```env
# Add required env vars (without actual values)
DATABASE_URL=
JWT_SECRET=
```

## File Structure
```
project-name/
├── src/
├── tests/
└── ...
```

## Session History

### $(date +%Y-%m-%d) - Initial Setup
- Created project structure
- Initialized repository
- Next: [What to do next session]

<!-- Add new sessions at the top -->

## Commands & Ports
- **Dev Server**: `npm run dev` (Port: )
- **Build**: `npm run build`
- **Test**: `npm test`
- **Deploy**: 

## Known Issues & TODOs
- [ ] Todo item 1
- [ ] Todo item 2

## Performance Metrics
- **Initial Load**: 
- **API Response Time**: 
- **Build Size**: 

## Notes & Ideas
- 

---
*Last Updated: $(date +"%Y-%m-%d %H:%M:%S")*
EOF

# Create helper scripts
echo "🔧 Creating helper scripts..."

cat > /home/claude/update-context.sh << 'EOF'
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
EOF
chmod +x /home/claude/update-context.sh

cat > /home/claude/new-project.sh << 'EOF'
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
EOF
chmod +x /home/claude/new-project.sh

# Add aliases to bashrc
echo "⚙️ Setting up aliases..."
cat >> /root/.bashrc << 'EOF'

# Claude CTO Environment
export CLAUDE_HOME="/home/claude"
export ANTHROPIC_API_KEY="your-key-here"  # UPDATE THIS!

# Navigation aliases
alias cdc='cd /home/claude'
alias cdp='cd /home/claude/projects'
alias cdw='cd /home/claude/workspace'
alias cdk='cd /home/claude/knowledge'

# Context management
alias read-context='cat /home/claude/CONTEXT.md'
alias edit-context='nano /home/claude/CONTEXT.md'
alias update-context='/home/claude/update-context.sh'
alias new-project='/home/claude/new-project.sh'

# Knowledge base shortcuts
alias solutions='nano /home/claude/knowledge/solutions.md'
alias fixes='nano /home/claude/knowledge/fixes.md'
alias snippets='nano /home/claude/knowledge/snippets.md'
alias patterns='nano /home/claude/knowledge/patterns.md'

# Quick functions
claude-start() {
    echo "📖 Loading Claude CTO context..."
    cd /home/claude
    echo "Active projects:"
    ls -1 projects/ 2>/dev/null | grep -v README
    echo ""
    echo "Run: claude-code \"Read CONTEXT.md first, then help with: [your task]\""
}

add-solution() {
    echo "" >> /home/claude/knowledge/solutions.md
    echo "### Problem: $1" >> /home/claude/knowledge/solutions.md
    echo "**Date**: $(date +%Y-%m-%d)" >> /home/claude/knowledge/solutions.md
    echo "**Solution added to knowledge base!**"
}

add-memory() {
    echo "" >> /home/claude/CONTEXT.md
    echo "### $(date +%Y-%m-%d) - Session Notes" >> /home/claude/CONTEXT.md
    echo "- **What was accomplished**: $1" >> /home/claude/CONTEXT.md
    /home/claude/update-context.sh
}

project-status() {
    echo "📊 Project Status Overview:"
    echo "------------------------"
    for proj in /home/claude/projects/*/PROJECT_CONTEXT.md; do
        if [ -f "$proj" ]; then
            dir=$(dirname "$proj")
            name=$(basename "$dir")
            status=$(grep -m1 "Status\*\*:" "$proj" | sed 's/.*Status\*\*: //')
            echo "• $name: $status"
        fi
    done
}

EOF

# Create initial daily log
echo "📝 Creating initial daily log..."
TODAY=$(date +%Y-%m-%d)
cat > /home/claude/logs/daily/$TODAY.md << EOF
# Daily Log - $TODAY

## Session Started: $(date +"%H:%M:%S")

### Environment Initialized
- Created directory structure
- Set up knowledge base
- Created templates
- Configured aliases

### Next Steps
1. Update CONTEXT.md with actual server details
2. Add Anthropic API key to .bashrc
3. Create first project using: new-project <name>
4. Start using Claude Code with context

---
*Generated by initialization script*
EOF

# Create a README for projects directory
cat > /home/claude/projects/README.md << 'EOF'
# Active Projects

This directory contains all active and in-development projects.
Each project has its own PROJECT_CONTEXT.md file for detailed tracking.

## How to create a new project:
```bash
new-project my-awesome-app
```

## Project Status Overview:
```bash
project-status
```

## Project Structure:
```
project-name/
├── PROJECT_CONTEXT.md  # Project-specific memory
├── src/                # Source code
├── tests/              # Test files
├── docs/               # Documentation
└── README.md           # Project readme
```
EOF

echo ""
echo "✅ Claude CTO Environment Initialized Successfully!"
echo ""
echo "📋 IMPORTANT NEXT STEPS:"
echo "1. Edit /root/.bashrc and add your ANTHROPIC_API_KEY"
echo "2. Run: source /root/.bashrc"
echo "3. Edit /home/claude/CONTEXT.md to add:"
echo "   - Your server IP"
echo "   - Your domain name"
echo "   - Any existing projects"
echo "4. Delete the FIRST RUN INITIALIZATION section from CONTEXT.md"
echo ""
echo "🎯 Quick Start Commands:"
echo "   claude-start     - Show context and projects"
echo "   new-project NAME - Create new project"
echo "   project-status   - View all projects"
echo "   update-context   - Update timestamps"
echo ""
echo "📚 Knowledge Base Files Created:"
echo "   - solutions.md   - Solved problems"
echo "   - fixes.md       - Bug fixes"
echo "   - snippets.md    - Code library"
echo "   - patterns.md    - Architecture patterns"
echo "   - optimizations.md - Performance tips"
echo ""
echo "🚀 Start Claude with: claude-code \"Read CONTEXT.md first, then [task]\""
