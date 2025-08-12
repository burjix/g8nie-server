# Repository Management Guidelines

## Core Instruction
**Use a separate GitHub repository for each project, and keep a file to guide which project goes to which repo.**

## Implementation Strategy

### 1. Repository Separation Rules
- Each distinct project gets its own dedicated GitHub repository
- Server infrastructure (`g8nie-server`) remains separate from application projects
- Landing pages, apps, services, tools, etc. all get individual repos

### 2. Repository Naming Convention
- Format: `project-name` (lowercase, hyphen-separated)
- Examples:
  - `g8nie-server` (infrastructure)
  - `g8nie-landing` (if landing page becomes separate)
  - `project-alpha` (application projects)
  - `tool-name` (utility tools)

### 3. Project Tracking System
- Maintain `PROJECT_REPOS.md` file in main server repo
- Maps each project to its corresponding repository
- Includes project status, description, and repository URL
- Updated whenever new projects are created

### 4. Workflow Process
1. **Project Creation**: Identify if new project needs separate repo
2. **Repository Setup**: Create new GitHub repo with proper naming
3. **Mapping Update**: Add entry to PROJECT_REPOS.md
4. **Development**: Work within project-specific repository
5. **Cross-Project References**: Link repositories when needed

### 5. Benefits
- **Clean Separation**: Each project has isolated codebase
- **Better Organization**: Easier to manage permissions, issues, releases
- **Scalability**: Can assign different teams to different repos
- **Deployment**: Each project can have independent CI/CD pipelines
- **Version Control**: Project-specific versioning and releases

### 6. Repository Categories
- **Infrastructure**: Server setup, configurations, deployments
- **Applications**: Full applications with frontend/backend
- **Libraries**: Reusable code components
- **Tools**: Utility scripts and automation
- **Documentation**: Project documentation and guides

## Implementation Date
2025-08-12 - Added to knowledge base and workflow