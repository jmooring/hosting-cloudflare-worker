# Hosting Test - Cloudflare Worker

This is a test of hosting a Hugo site on a Cloudflare Worker.

This site:

1. Includes content from a Hugo module
1. Transpiles Sass to CSS using Dart Sass
1. Performs vendor prefixing of CSS rules using the postcss, postcss-cli, and autoprefixer Node.js packages
1. Processes CSS files using the tailwindcss and @tailwindcss-cli Node.js packages
1. Encodes images to the WebP format to verify that we're using Hugo's extended edition
1. Includes a content file named hugö.md to verify that the Git `core.quotepath` setting is `false`[^1].

## Controlling build tool versions

In a Cloudflare Worker project, environment variables in your `wrangler.toml` file's `[vars]` section are for runtime only. They are not accessible during the build process, so you can't use them to specify which version of a build tool to use. For example, setting `HUGO_VERSION` in this section won't affect the version of Hugo that builds your site or be available to your build scripts.

To control which tool version is used, you can define build-time environment variables in the Cloudflare dashboard under your Worker's settings. These are available to the build pipeline for your project:

Build tool|Environment variable
:--|:--
Go|`GO_VERSION`
Hugo|`HUGO_VERSION`
Node.js|`NODE_VERSION`

However, as of 31 July 2025, setting the HUGO_VERSION variable in the dashboard installs the standard edition of Hugo, not the extended version needed for features like WebP image encoding.

To simplify your setup and ensure you get the correct tool versions, it's a better practice to manage all build tool versions directly in your build script. This approach eliminates the need to split your settings between the dashboard and your project's code.

## Other

Cloudflare uses Zstd compression, which is faster to compress/decompress than Brotli, but the compression ratio is generally lower than Brotli. This difference is noise.

This repository includes uses a [GitHub Action] to update `scheduled-file-update.txt` every day at approximately[^2] 9:57 PM UTC. Each update triggers a Cloudflare Worker build. This is not required for most sites, and is disabled by default.

[GitHub Action]: https://github.com/jmooring/hosting-cloudflare-worker/blob/main/.github/workflows/scheduled-file-update.yaml

[^1]: See [issue #9810](https://github.com/gohugoio/hugo/issues/9810). Git's `core.quotepath` setting is `false` if `/tests/hugö` has a non-zero "last modified" date.

[^2]: The time at which the cron job actually runs varies depending on GitHub's load.
