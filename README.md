# Telegraf Docker Image with Utilities

This is an extension of the base Telegraf docker image that adds in a bunch of utilities that may be needed for some input plugins.

Based on:

* https://github.com/influxdata/influxdata-docker
* https://github.com/nuntz/telegraf-snmp

## Images and tags

* `ghcr.io/evopix/telegraf-utils:<telegraf-version>` and `:latest` — published
  automatically by `.github/workflows/docker-publish.yml` on every push to
  `master` that touches the `Dockerfile`. The version tag tracks the pinned
  `FROM telegraf:` version. A GitHub release `v<telegraf-version>` is cut the
  first time a new Telegraf version is published.
* `evopix/telegraf-utils` on Docker Hub — same tags, opt-in: set the
  repository variable `PUSH_TO_DOCKERHUB=true` plus the
  `DOCKERHUB_USERNAME` / `DOCKERHUB_TOKEN` secrets.

After the first GHCR push, check the package's visibility settings (new
container packages may default to private).

## Automatic base-image updates

`renovate.json` watches the `telegraf` Docker tag: patch bumps open PRs that
automerge once the workflow's validation build passes; minor/major bumps open
PRs for human review (a minor jump can change input behavior). Merging a bump
PR triggers the publish workflow above.
