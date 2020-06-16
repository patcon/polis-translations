# polis-translations

Configuration files for managing the project's translation server.

**Note:** For now, this is just a demo.

## Technology Used

[**Mojito**](https://www.mojito.global/) is an automation platform that enabled continuous localization.

[**Heroku**](https://www.heroku.com/what) is a platform for easily deploying applications.

[**Heroku CLI**](https://devcenter.heroku.com/articles/heroku-cli) is a command-line tool to manage Heroku apps directly from the terminal.

[**Heroku CLI Plugin: Java**](https://github.com/heroku/plugin-java) is for working with Java applications on Heroku.

We use `make` to run helper tasks. To see the available tasks, run `make` without any arguments:

```
$ make
Usage: make <command>

where <command> is one of the following:

setup                prepare workstation and download deployable files
config-pull          Override local .env with heroku envvvars
local                Run webapp locally using local .env
deploy               Deploy the app to Heroku
console              Run a remote shell console on Heroku
delete-db            Delete the remote Heroku database
db                   Create the remote Heroku database
reset-db             Delete and recreate the remote Heroku database
stop                 Stop the Heroku webapp
start                Start the Heroku webapp
logs                 Tail the remote Heroku logs
fresh                Purge and recreate the database and deploy the current app fresh
fresh-tail           Start fresh, and immediately tail the logs
```

## Setup

Requirement: [Install][install] the Heroku CLI.

   [install]: https://devcenter.heroku.com/articles/heroku-cli#download-and-install

On initial setup on your workstation, run:

```
make setup
```

## Run Locally

```
# Edit to facilitate GitHub login.
cp .env.sample .env

make local
```

Then visit http://localhost:5000

## Deployment

**Note:** You'll need contributor access on the Heroku repo.

```
heroku addons:create jawsdb:kitefin --version=5.7
heroku config:set GITHUB_CLIENT_ID=xxxxxxxxxx
heroku config:set GITHUB_CLIENT_SECRET=xxxxxxxxxxx
heroku config:set MOJITO_CLI_USERNAME=admin
heroku config:set MOJITO_CLI_PASSWORD=xxxxxxxxxx
make deploy
```

Then visit https://polis-translations.herokuapp.com

## Notes

- Authentication to the webapp is done via GitHub account login. [(docs)](https://www.mojito.global//docs/guides/authentication/#example-with-github)
  - You'll need to [create a GitHub app][create-gh-app] if you're creating a new translation server.
  - Any GitHub user can sign in.
  - There's currently no way to control user's access levels -- everyone gets full authorization. [chat context.](https://gitter.im/box/mojito?at=5ee2ab285782a31278f3d55c)
- [Any MySQL or MariaDB addon within Heroku][mysql-addons] can be used.
  - ClearDB seems to not work, as the `--version` flag isn't respected, and MySQL 5.7 can't be used.

   [create-gh-app]: https://developer.github.com/apps/building-github-apps/creating-a-github-app/
   [mysql-addons]: https://elements.heroku.com/search/addons?q=mysql
