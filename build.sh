#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Builds a Hugo site hosted on a Cloudflare Worker.
#
# The Cloudflare Worker automatically installs Node.js dependencies.
#------------------------------------------------------------------------------

main() {

  DART_SASS_VERSION=1.89.2
  GO_VERSION=1.24.5
  HUGO_VERSION=0.148.2
  NODE_VERSION=24.4.1

  export TZ=Europe/Oslo

  # Install Dart Sass
  echo "Installing Dart Sass ${DART_SASS_VERSION}..."
  curl -sLJO "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
  tar -C "${HOME}/.local" -xf "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
  rm dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz
  export PATH=${HOME}/.local/dart-sass:$PATH

  # Install Go
  echo "Installing Go ${GO_VERSION}..."
  curl -sLJO "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
  tar -C "${HOME}/.local" -xf go${GO_VERSION}.linux-amd64.tar.gz
  rm go${GO_VERSION}.linux-amd64.tar.gz
  export PATH=${HOME}/.local/go/bin:$PATH

  # Install Hugo
  echo "Installing Hugo ${HUGO_VERSION}..."
  curl -sLJO https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz
  mkdir "${HOME}/.local/hugo"
  tar -C "${HOME}/.local/hugo" -xf hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz
  rm hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz
  export PATH=${HOME}/.local/hugo:$PATH

  # Install Node.js
  echo "Installing Node.js ${NODE_VERSION}..."
  curl -sLJO https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz
  tar -C "${HOME}/.local" -xf node-v${NODE_VERSION}-linux-x64.tar.xz
  rm node-v${NODE_VERSION}-linux-x64.tar.xz
  export PATH=${HOME}/.local/node-v${NODE_VERSION}-linux-x64/bin:$PATH

  # Verify installed versions
  echo "Verifying installations..."
  echo Dart Sass: "$(sass --version)"
  echo Go: "$(go version)"
  echo Hugo: "$(hugo version)"
  echo Node.js: "$(node --version)"

  # https://gohugo.io/methods/page/gitinfo/#hosting-considerations
  if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    git fetch --unshallow
  fi

  # https://github.com/gohugoio/hugo/issues/9810
  git config core.quotepath false

  # Build the site.
  hugo --gc --minify

}

set -euo pipefail
main "$@"
