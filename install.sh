#!/bin/bash
set -e

echo "=== Обновление системы и установка необходимых пакетов ==="
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential file unzip jq

echo "=== Установка Rust ==="
curl https://sh.rustup.rs -sSf | sh -s -- -y
# Обновляем переменную окружения Cargo для текущей сессии
source "$HOME/.cargo/env"
rustc --version

echo "=== Установка sfoundryup ==="
curl -L -H "Accept: application/vnd.github.v3.raw" \
     "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" | bash

# Обновляем окружение, если изменилось ~/.bashrc
source ~/.bashrc

echo "=== Обновляем PATH: добавляем /root/.seismic/bin в PATH ==="
export PATH=/root/.seismic/bin:$PATH

echo "=== Запуск sfoundryup (это может занять от 5 до 20 минут) ==="
sfoundryup

echo "=== Клонирование репозитория try-devnet и переход в каталог контрактов ==="
git clone --recurse-submodules https://github.com/SeismicSystems/try-devnet.git
cd try-devnet/packages/contract/

echo "=== Развёртывание контракта ==="
bash script/deploy.sh

echo "=== ВАЖНО! ==="
echo "Перейдите по ссылке: https://faucet-2.seismicdev.net/"
echo "и пополните кошелек (адрес указан в выводе deploy.sh) тестовыми ETH (0.1 ETH минимум)."
read -p "Нажмите Enter после подтверждения пополнения кошелька..."

echo "=== Установка Bun для взаимодействия с контрактом ==="
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc
bun --version

echo "=== Переход в каталог cli и установка зависимостей ==="
cd ../cli/
bun install

echo "=== Выполнение транзакции ==="
bash script/transact.sh

echo "=== DONE! ==="
