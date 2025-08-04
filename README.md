# Hosting Test - Cloudflare Worker

This is a test of hosting a Hugo project on a Cloudflare Worker.

With the exception of the Webhook page and its template, all components are imported from the [`jmooring/hugo-module-feature-test`][] module. See its [README][] file for details.

[`jmooring/hugo-module-feature-test`]: https://github.com/jmooring/hugo-module-feature-test
[README]: https://github.com/jmooring/hugo-module-feature-test?tab=readme-ov-file#readme

## Controlling build tool versions

In a Cloudflare Worker project, environment variables in your `wrangler.toml` file's `[vars]` section are for runtime only. They are not accessible during the build process, so you can't use them to specify which version of a build tool to use. For example, setting `HUGO_VERSION` in this section won't affect the version of Hugo that builds your project or be available to your build scripts.

To control which tool version is used, you can define build-time environment variables in the Cloudflare dashboard under your Worker's settings. These are available to the build pipeline for your project:

Build tool|Environment variable
:--|:--
Go|`GO_VERSION`
Hugo|`HUGO_VERSION`
Node.js|`NODE_VERSION`

To simplify your setup and ensure you get the correct tool versions, it's a better practice to manage all build tool versions directly in your build script. This approach eliminates the need to split your settings between the dashboard and your project's code.

## Scheduled builds

The scheduled workflow runs daily at 7:42 UTC.[^1] It triggers a Cloudflare deploy hook by sending an HTTP POST request to the URL stored in a GitHub Actions secret named `CLOUDFLARE_DEPLOY_HOOK`. This initiates a Cloudflare build identical to one triggered by a code commit.

To configure this, create a deploy hook in the Cloudflare dashboard under your Worker's settings, then add the resulting URL as a GitHub Actions secret named `CLOUDFLARE_DEPLOY_HOOK`.

[^1]: The time at which the cron job actually runs varies depending on GitHub's load.
