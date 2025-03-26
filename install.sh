#!/bin/bash
# Этот скрипт установит Rust, jq, build-essential (на Linux), скачает и запустит sfoundryup,
# а затем сохранит в файлы строки с "key:" и "address:" из вывода sfoundryup.

# Если вы работаете в Linux, убедитесь, что установлены инструменты сборки
if [ "$(uname)" != "Darwin" ]; then
    echo "Устанавливаем build-essential..."
    sudo apt-get update && sudo apt-get install -y build-essential
fi

# Устанавливаем Rust (если уже установлен, просто обновит конфигурацию)
echo "Устанавливаем Rust..."
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Подключаем Cargo (обновите переменную PATH текущей сессии)
echo "Подключаем Rust (Cargo)..."
source "$HOME/.cargo/env"

# Проверяем наличие jq и устанавливаем, если не найден
if ! command -v jq >/dev/null 2>&1; then
    if [ "$(uname)" = "Darwin" ]; then
        echo "Устанавливаем jq для macOS..."
        brew install jq
    else
        echo "Устанавливаем jq для Linux..."
        sudo apt-get update && sudo apt-get install -y jq
    fi
fi

# Скачиваем и устанавливаем sfoundryup
echo "Устанавливаем sfoundryup..."
curl -L -H "Accept: application/vnd.github.v3.raw" "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" | bash

# Обновляем окружение (или перезапустите терминал, если необходимо)
echo "Обновляем окружение..."
source ~/.bashrc

# Запускаем sfoundryup и сохраняем вывод
echo "Запускаем sfoundryup (это может занять время, от 5 до 60 минут)..."
output=$(sfoundryup)

# Сохраняем вывод в лог-файл и фильтруем строки с ключом и адресом
echo "$output" | tee ~/sfoundryup.log
echo "$output" | grep -i "key:" > ~/sfoundry_key.txt
echo "$output" | grep -i "address:" > ~/sfoundry_address.txt

echo "Установка завершена. Проверьте файлы ~/sfoundry_key.txt и ~/sfoundry_address.txt для получения информации о ключе и адресе."
