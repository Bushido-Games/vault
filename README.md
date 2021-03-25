# Vault

Repository with configuration and helper scripts of HashiCorp's vault.

TODO: Adding / Getting creds help

## Scripts

### dc

Wrapper for docker-compose. Retrieves project environmental variables and passes them to the docker-compose file

#### Installation:
Copy `scripts/dc` file to any $PATH folder (e.g `~/bin/` or `/usr/bin/`)

#### Usage:

Call:
- `dc -h` to render help message.
- `dc -p PROJECT_NAME` to retrieve specific project environment. By default, the script will try to extract the project name from `package.json` file.
- `dc -e staging` to retrieve staging environment variables. By default local environment variables are retrieved.
