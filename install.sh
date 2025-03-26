#!/bin/bash
curl https://sh.rustup.rs -sSf | sh -s -- -y && source "$HOME/.cargo/env" && \
command -v jq >/dev/null 2>&1 || { \
    if [ "$(uname)" = "Darwin" ]; then \
        brew install jq; \
    else \
        sudo apt-get update && sudo apt-get install -y jq; \
    fi; \
} && \
curl -L -H "Accept: application/vnd.github.v3.raw" "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" | bash && \
source ~/.bashrc && \
output=$(sfoundryup) && \
echo "$output" | tee ~/sfoundryup.log && \
echo "$output" | grep -i "key:" > ~/sfoundry_key.txt && \
echo "$output" | grep -i "address:" > ~/sfoundry_address.txt
