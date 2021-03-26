# Vault

Repository with configuration and helper scripts of HashiCorp's vault.  

## Usage

First thing you need to do is authorization. You need to [generate Github personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)  with the `read:org` scope. Store it to $GITHUB_TOKEN local environment by calling:

`export GITHUB_TOKEN=YOUR-GITHUB-PERSONAL-ACCESS-TOKEN`

For convenience add above command to the `~/.bashrc` or `~/.bash_profile` and restart your terminal.

You also need to set $VAULT_ADDR environment to point to the vault server address.

`export VAULT_ADDR="http://10.0.21.11:8200"`

**Important!** For successful connection you need to use VPN.

Install Vault:
```angular2html
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault
```

You should be ready to login to the vault calling:

`vault login -method=github token=${GITHUB_TOKEN}`

Now you can use vault api to retrieve, create, update and delete variables:

- Create / Update: `vault kv put bushido/local/hello foo=world`
- Retrieve: `vault kv get bushido/local/hello`
- Delete: `vault kv delete bushido/local/hello`

The path is constructed from three parts:
1. `bushido/` - constant prefix for all paths.
1. `ENVIRONMENT/` - this can take two options: `local` for local development or `staging` for staging deployments.
1. `PROJECT_NAME` - a project name. This should exactly match with a project repository name. 

For more details, refer to the [Vault documentation](https://www.vaultproject.io/docs/secrets/kv/kv-v2)

## Scripts

### envvault

Helper for docker-compose. Retrieves project environmental variables and passes them to the docker-compose file

#### Installation:
- Copy `scripts/envvault` file to any $PATH folder (e.g. `~/bin/` or `/usr/bin/`). 
- Make sure $GITHUB_TOKEN variable is defined

#### Usage:

Options:
- `-h|--help` - render help message.
- `-p|--project PROJECT_NAME` - retrieve specific project environment. By default, the script will try to extract the project name from `package.json` file.
- `-e|--env local|staging` - retrieve variables assigned to selected environment. Default: local.
- `COMMAND` command to run

Examples:

- `envvault -p shop-managment-tools env | grep BUSHIDO` - useful for quick test if the env were successfully retrieved
- `envvault -p shop-managment-tools docker-compose up`
- `envvault -p shop-managment-tools docker-compose run priceManager`
