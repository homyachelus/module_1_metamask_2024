# Модуль 1 задания 2024 года

## Установка и запуск

Инициализация и установка зависимостей в папке проекта hardhat:
```shell
mkdir hardhat
cd hardhat
npm init -y
npm install --save-dev hardhat@2
npx hardhat
```
Также установка опензеппелин:
```shell
npm install @openzeppelin/contracts
```
* Запуск локальной сети осуществился командой: `npx hardhat node`

* Запуск скрипта деплоя осуществился командой: `npx hardhat run ./scripts/deploy.ts --network localhost`

## Использование функций

### Хардхат

В папке с контарктами по пути `hardhat/contracts` лежат файлы с написанными контрактами

В папке **scripts** есть файл **deploy.ts** написанные функции, нужные для обеспечения требуемого старта

### Фронтенд

## Себе
Писать контракт на версии солидити 0.8.24(без ^)

***см hardhat.config.ts***

Если такая ошибка: error TS5011: The common source directory of 'tsconfig.json' is './scripts'. The 'rootDir' setting must be explicitly set to this or another path to adjust your output's file layout.
То нужно добавить **"rootDir": "."** в тсконфиг