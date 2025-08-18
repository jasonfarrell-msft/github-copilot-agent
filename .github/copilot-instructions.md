# GitHub Copilot Agent Repository

GitHub Copilot Agent is a minimal Python project designed for GitHub Copilot agent functionality. This repository contains basic setup infrastructure and scaffolding for future development.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Environment Setup
- Python 3.13 is required and should be available in the environment
- Verify Python version: `python3 --version`
- SQLite3 is required for database operations
- Install SQLite: `sudo apt update && sudo apt install sqlite3` -- takes 1-3 minutes. NEVER CANCEL. Set timeout to 5+ minutes.
- Verify SQLite installation: `sqlite3 --version`

### Dependency Management
- Install Python dependencies: `pip install -r src/requirements.txt` -- typically takes <1 minute under normal conditions. NEVER CANCEL. Set timeout to 10+ minutes.
- **KNOWN ISSUE**: pip install may fail due to network/firewall limitations with PyPI. If this occurs, retry with longer timeouts or check network connectivity.
- Current dependencies: requests (HTTP library)
- Test dependency availability: `python3 -c "import requests; print('requests module is available')"`

### Repository Structure
```
.
├── .github/
│   └── workflows/
│       └── copilot-setup-steps.yml    # GitHub workflow for setup steps
├── src/
│   └── requirements.txt               # Python dependencies (contains: requests)
└── .git/                             # Git repository data
```

### Build Process
The repository follows the GitHub workflow defined in `.github/workflows/copilot-setup-steps.yml`:

1. Checkout code
2. Set up Python 3.13 with pip cache
3. Install Python dependencies: `pip install -r src/requirements.txt`
4. Install SQLite: `sudo apt update && sudo apt install sqlite3`

**CRITICAL**: All dependency installation commands should use extended timeouts:
- `pip install` commands: Set timeout to 10+ minutes minimum
- `apt update && apt install`: Set timeout to 5+ minutes minimum
- **NEVER CANCEL** any package installation commands even if they appear to hang

### Testing
- **NO TESTS CURRENTLY EXIST** - This is scaffolding repository with minimal code
- When tests are added, they should follow Python testing conventions (pytest recommended)
- Test command structure (when implemented): `python -m pytest`

### Code Quality
- **NO LINTING CONFIGURATION EXISTS** - Add when actual code is developed
- Standard Python linting tools recommended: flake8, black, pylint
- Future linting command structure: `flake8 src/` or `python -m black src/`

## Validation

### Environment Validation
- Always verify Python 3.13 is available: `python3 --version`
- Always verify SQLite is installed: `sqlite3 --version`
- Test Python import capabilities: `python3 -c "import sys; print(sys.version)"`

### Dependency Validation
- Test that requests module can be imported: `python3 -c "import requests; print('requests available')`
- **If import fails**, dependencies need to be reinstalled despite potential network issues

### Manual Validation Steps
Since this is a minimal repository:
1. Verify Python environment setup
2. Confirm all dependencies install successfully
3. Test basic Python functionality
4. **NO APPLICATION TO RUN** - This is infrastructure only

## Common Tasks

### Repository Structure Output
```bash
ls -la
```
Expected output:
```
total 20
drwxr-xr-x 5 runner docker 4096 Aug 18 12:46 .
drwxr-xr-x 3 runner docker 4096 Aug 18 12:46 ..
drwxr-xr-x 7 runner docker 4096 Aug 18 12:52 .git
drwxr-xr-x 3 runner docker 4096 Aug 18 12:46 .github
drwxr-xr-x 2 runner docker 4096 Aug 18 12:46 src
```

### Requirements File Content
```bash
cat src/requirements.txt
```
Expected output:
```
requests
```

### Workflow File Analysis
```bash
cat .github/workflows/copilot-setup-steps.yml
```
Shows the complete setup process that should be followed.

## Known Issues and Limitations

### Network Connectivity
- **CRITICAL**: pip install may fail with timeout errors due to network limitations
- **SYMPTOM**: `ReadTimeoutError: HTTPSConnectionPool(host='pypi.org', port=443): Read timed out.`
- **MITIGATION**: 
  - Use extended timeouts (10+ minutes for pip commands)
  - Retry failed installations
  - Check if packages are already installed before attempting installation

### No Application Code
- This repository contains only infrastructure scaffolding
- No actual application logic exists yet
- Focus on environment setup and preparation for future development

### No CI/CD Beyond Setup
- Only one workflow exists: copilot-setup-steps.yml
- No build, test, or deployment pipelines are configured
- No automated quality checks are in place

## Development Guidelines

### Adding New Features
- Follow Python best practices and PEP 8 style guidelines
- Add appropriate tests when implementing functionality
- Update requirements.txt when adding new dependencies
- Ensure all new code works with Python 3.13

### Future Enhancements Needed
- Add testing framework (pytest recommended)
- Add code quality tools (flake8, black, pylint)
- Add actual application functionality
- Add comprehensive CI/CD pipeline
- Add documentation for application features

### Git Workflow
- Follow standard Git practices
- Commit regularly with descriptive messages
- Test changes before committing
- Update this instructions file when adding significant new functionality

## Troubleshooting

### Python Import Errors
- Verify Python version: `python3 --version`
- Check if dependencies are installed: `pip list`
- Reinstall dependencies if needed (with extended timeout): `pip install -r src/requirements.txt`

### Network/Installation Issues
- **DO NOT** immediately assume failure if pip commands appear to hang
- Allow at least 10 minutes for package installations to complete
- Check for existing installations before reinstalling
- Verify internet connectivity if persistent issues occur

### Environment Issues
- Ensure you're working in the correct directory: `/home/runner/work/github-copilot-agent/github-copilot-agent`
- Verify all required system packages are available
- Check that workflow setup steps have been completed successfully