// BSLLS:ExportVariables-off
// BSLLS:CanonicalSpellingKeywords-off

// Номер упаковки (можно использовать порядковый номер упаковки заказа или номер заказа),
// уникален в пределах заказа.
// Идентификатор заказа в ИС Клиента
var number export;

// Общий вес (в граммах)
var weight export;

// Габариты упаковки. Длина (в сантиметрах)
var length export;

// Габариты упаковки. Ширина (в сантиметрах)
var width export;

// Габариты упаковки. Высота (в сантиметрах)
var height export;

// Комментарий к упаковке
// Обязательно и только для заказа типа "доставка"
var comment export;

// Позиции товаров в упаковке
// Только для заказов "интернет-магазин"
// Максимум 126 уникальных позиций в заказе
// Общее количество товаров в заказе может быть от 1 до 10000
var items export;

items = Новый Массив;