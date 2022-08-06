# CLI-утилита для API СДЭК

## Установка

```
opm install cdekos
```

## Настройка

### Переменные среды

* `CDEKOS_ACCOUNT`, `CDEKOS_SECRET` - Идентификатор и пароль из [https://lk.cdek.ru/integration] (личного кабинета)
* `CDEKOS_ENVIRONMENT` - Если указано значение `DEV`, `DEVELOPMENT`, `TEST`, то cdekos будет работать с тестовым API.
* `CDEKOS_PROTECTION` - Если указано значение `1`, `YES`, `Y`, включается режим защиты. Режим защиты означает, что вызов некоторых команд вызовет ошибку. Как правило это команды добавления/изменения/отмены заказа.

## Доступные команды

### Список офисов

```
cdekos pg
cdekos points-get
```
см. https://api-docs.cdek.ru/36982648.html

### Список регионов

```
cdekos rgg -c=RU,KZ
cdekos regions-get --country=RU,KZ
```
см. https://api-docs.cdek.ru/33829418.html

### Список городов

```
cdekos ctg -r=182
cdekos cities-get --region=182
```
см. https://api-docs.cdek.ru/33829437.html

### Данные заказа

```
cdekos og [-i 12345678-1234-1234-1234-123456789012] [-m ABC-123] [-c 123000123456] 
cdekos order-get [-id 12345678-1234-1234-1234-123456789012] [-im ABC-123] [-cdek 123000123456] 
```
см. https://api-docs.cdek.ru/29923975.html

### Данные чека отложенного платежа

```
cdekos cg  [-i 12345678-1234-1234-1234-123456789012] [-m ABC-123] [-c 123000123456] 
cdekos check-get [-id 12345678-1234-1234-1234-123456789012] [-im ABC-123] [-cdek 123000123456]  
```
см. https://api-docs.cdek.ru/68257388.html

### Генерация этикеток

```
cdekos bp  [-i 12345678-1234-1234-1234-123456789012][-c 123000123456] -f A4|A5 -l RUS
cdekos barcodes-post [-id 12345678-1234-1234-1234-123456789012] [-cdek 123000123456] --format A4|A5 --lang RUS
```

Не работает в защищенном режиме.
см. https://api-docs.cdek.ru/68257388.html

### Получение этикеток этикеток

```
cdekos bp  [-u 12345678-1234-1234-1234-123456789012]
cdekos barcodes-post [-uuid 12345678-1234-1234-1234-123456789012] [-cdek 123000123456]
```

Не работает в защищенном режиме.
см. https://api-docs.cdek.ru/36967298.html