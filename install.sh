#!/bin/bash
set -e

echo "=== Обновление системы и установка необходимых пакетов ==="
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential file unzip jq

echo "=== Установка Rust ==="
curl https://sh.rustup.rs -sSf | sh -s -- -y
# Обновляем переменную окружения для Cargo
source "$HOME/.cargo/env"
rustc --version

echo "=== Установка sfoundryup ==="
curl -L -H "Accept: application/vnd.github.v3.raw" \
     "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" | bash

# Обновляем окружение (если изменялось ~/.bashrc)
source ~/.bashrc

echo "=== Запуск sfoundryup (это может занять от 5 до 20 минут) ==="
sfoundryup

echo "=== Клонирование репозитория try-devnet и переход в каталог контрактов ==="
git clone --recurse-submodules https://github.com/SeismicSystems/try-devnet.git
cd try-devnet/packages/contract/

echo "=== Развёртывание контракта ==="
bash script/deploy.sh

echo "=== ВАЖНО! ==="
echo "Перейдите по ссылке https://faucet-2.seismicdev.net/ и пополните кошелек (адрес, указанный в выводе deploy.sh) 0.1 ETH."
read -p "Нажмите Enter после того, как транзакция будет подтверждена..."

echo "=== Установка Bun для взаимодействия с контрактом ==="
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc
bun --version

echo "=== Переход в каталог cli и установка зависимостей ==="
cd ../cli/
bun install

echo "=== Выполнение транзакции ==="
bash script/transact.sh

echo "=== Готово! Дополнительные ссылки Seismic Devnet ==="
echo "Network Name: Seismic devnet"
echo "Currency Symbol: ETH"
echo "Chain ID: 5124"
echo "RPC URL (HTTP): https://node-2.seismicdev.net/rpc"
echo "RPC URL (WebSocket): wss://node-2.seismicdev.net/ws"
echo "Explorer: https://explorer-2.seismicdev.net"
echo "Faucet: https://faucet-2.seismicdev.net/"
echo "Starter Repo: https://github.com/SeismicSystems/seismic-starter"

echo "=== DONE! ==="
