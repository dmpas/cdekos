// BSLLS:ExportVariables-off
// BSLLS:CanonicalSpellingKeywords-off

// Тип заказа:
// 1 - "интернет-магазин" (только для договора типа "Договор с ИМ")
// 2 - "доставка" (для любого договора)
// 
// По умолчанию - 1
var type export;

// Номер заказа в ИС Клиента (если не передан, будет присвоен номер заказа в ИС СДЭК - uuid)
// 
// Только для заказов "интернет-магазин"
// Может содержать только цифры, буквы латинского алфавита или спецсимволы (формат ASCII)
var number export;

// Код тарифа
var tariff_code export;

// Комментарий к заказу
var comment export;

// Код ПВЗ СДЭК, на который будет производиться самостоятельный привоз клиентом
// Не может использоваться одновременно с from_location
var shipment_point export;

// Код офиса СДЭК (ПВЗ/постамата), на который будет доставлена посылка
// Не может использоваться одновременно с to_location
var delivery_point export;

// Дата инвойса
// Только для международных заказов "интернет-магазин"
var date_invoice export;

// Грузоотправитель
// Только для международных заказов "интернет-магазин"
var shipper_name export;

// Адрес грузоотправителя
// Только для международных заказов "интернет-магазин"
var shipper_address export;

// Доп. сбор за доставку, которую ИМ берет с получателя.
// Только для заказов "интернет-магазин".
var delivery_recipient_cost export;

// Доп. сбор за доставку (которую ИМ берет с получателя) в зависимости от суммы заказа
// Только для заказов "интернет-магазин".  Возможно указать несколько порогов.
var delivery_recipient_cost_adv export;

// Отправитель
var sender export;

// Реквизиты истинного продавца
// Только для заказов "интернет-магазин"
var seller export;

// Получатель
var recipient export;

// Адрес отправления
// Не может использоваться одновременно с shipment_point
var from_location export;

// Адрес получения
// Не может использоваться одновременно с delivery_point
var to_location export;

// Дополнительные услуги
var services export;

// Список информации по местам (упаковкам)
// Количество мест в заказе может быть от 1 до 255
var packages export;

// Необходимость сформировать печатную форму по заказу
// Может принимать значения:
// barcode - ШК мест (число копий - 1)
// waybill - квитанция (число копий - 2)
var print export;

packages = New Array;
delivery_recipient_cost = New OrderDeliveryRecipientCost;
delivery_recipient_cost_adv = New OrderDeliveryRecipientCostAdvanced;
sender = New OrderContact;
seller = New OrderSeller;
recipient = New OrderContact;
from_location = New OrderLocation;
to_location = New OrderLocation;
services = New Array;