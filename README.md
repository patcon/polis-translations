# polis-translations

Configuration files for managing the project's translation server.

**Note:** For now, this is just a demo.

## Technology Used

[**Mojito**](https://www.mojito.global/) is an automation platform that enabled continuous localization.

[**Heroku**](https://www.heroku.com/what) is a platform for easily deploying applications.

[**Heroku CLI**](https://devcenter.heroku.com/articles/heroku-cli) is a command-line tool to manage Heroku apps directly from the terminal.

[**Heroku CLI Plugin: Java**](https://github.com/heroku/plugin-java) is for working with Java applications on Heroku.

## Setup

Requirement: [Install][install] the Heroku CLI.

   [install]: https://devcenter.heroku.com/articles/heroku-cli#download-and-install

On initial setup on your workstation, run:

```
heroku plugins:install java
wget --output-document=mojito-webapp.jar https://github.com/box/mojito/releases/download/v0.110/mojito-webapp-0.110.jar
```

## Run Locally

```
heroku local web
```

Then visit http://localhost:5000

## Deployment

**Note:** You'll need contributor access on the Heroku repo.

```
heroku deploy:jar mojito-webapp.jar --includes application.properties --app polis-translations
```

Then visit https://polis-translations.herokuapp.com
