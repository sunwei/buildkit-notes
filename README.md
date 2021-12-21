# domain-writing

## Usage

Build documentation locally
```shell
$ make docs
```

Publish
```shell
$ git push 
```

Use GitHub pages with customized domain for our writing.

### Publish site with github actions
For github actions.

1. Apply token: https://github.com/settings/tokens
2. Refer to ./settings/secrets/actions, fill token with name: "GHP_TOKEN"
3. Custom domain: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site

Done!
