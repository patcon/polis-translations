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
make setup
```

## Run Locally

```
# Edit to facilitate GitHub login.
cp .env.sample .env

heroku local web
```

Then visit http://localhost:5000

## Deployment

**Note:** You'll need contributor access on the Heroku repo.

```
heroku addons:create jawsdb:kitefin --version=5.7
heroku config:set GITHUB_CLIENT_ID=xxxxxxxxxx
heroku config:set GITHUB_CLIENT_SECRET=xxxxxxxxxxx
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
