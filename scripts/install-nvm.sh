#!/usr/bin/env sh

set -e

installNVM() {
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
}

installNVM