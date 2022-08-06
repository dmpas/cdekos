// BSLLS:ExportVariables-off
// BSLLS:CanonicalSpellingKeywords-off

// Порог стоимости товара (действует по условию меньше или равно) в целых единицах валюты
var threshold export;

// Доп. сбор за доставку товаров, общая стоимость которых попадает в интервал
var sum export;

// Сумма НДС
var vat_sum export;

// Ставка НДС (значение - 0, 10, 20, null - нет НДС)
var vat_rate export;

threshold = 0;
sum = 0;
vat_sum = 0;
