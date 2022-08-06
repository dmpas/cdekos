
// Выполняет запрос к СДЭК
//
// Параметры:
// 	Метод - Строка - Вызываемый метод СДЭК. Например: "GET /check", "POST /orders/{orderId}"
// 	ПараметрыЗапроса - Структура - Данные, передаваемые методу
// 	ПараметрыУчетнойЗаписи -Структура - см. ПараметрыУчетнойЗаписиСДЭК()
//
// Возвращаемое значение:
// 	Соответствие - разобранный JSON от ApiShip
Функция ВыполнитьЗапросСДЭК(Знач Метод,
		Знач ПараметрыЗапроса = Неопределено,
		Знач ПараметрыУчетнойЗаписи = Неопределено) Экспорт
	
	ВыполнитьАвторизациюСДЭК(ПараметрыУчетнойЗаписи);
	
	ОтветОрдер = ПолучитьОтветСДЭК(ПараметрыУчетнойЗаписи, Метод, ПараметрыЗапроса);
	ТекстОтвета = ОтветОрдер.ПолучитьТелоКакСтроку();
	
	ЧтениеОтвета = Новый ЧтениеJSON;
	ЧтениеОтвета.УстановитьСтроку(ТекстОтвета);
	
	Ответ = ПрочитатьJSON(ЧтениеОтвета, Истина);
	
	ЧтениеОтвета.Закрыть();
	
	Возврат Ответ;
	
КонецФункции

// Возвращает параметры для формирования запросов
//
// Возвращаемое значение:
// 	Структура:
// 		* Адрес - Строка
// 		* Токен - Строка
// 		* ПрефиксApi - Строка
Функция ПараметрыУчетнойЗаписиСДЭК() Экспорт
	
	ТестовыйРежим = ТестоваяСреда();
	
	Результат = Новый Структура;
	Результат.Вставить("Адрес", ?(ТестовыйРежим, "https://api.edu.cdek.ru", "https://api.cdek.ru"));
	Результат.Вставить("Ключ", ИдентификаторКлиента());
	Результат.Вставить("Секрет", СекретКлиента());
	Результат.Вставить("Токен", Неопределено);
	Результат.Вставить("СрокДействияТокена", Неопределено);
	Результат.Вставить("ПрефиксApi", "/v2");
	Возврат Результат;
	
КонецФункции

Функция ТестоваяСреда()
	Среда = ПолучитьПеременнуюСреды("CDEKOS_ENVIRONMENT");
	Возврат ВРЕГ(Среда) = "DEV"
		Или ВРЕГ(Среда) = "DEVELOPMENT"
		Или ВРЕГ(Среда) = "TEST"
	;
КонецФункции

Функция ИдентификаторКлиента()
	Возврат ПолучитьПеременнуюСреды("CDEKOS_ACCOUNT");
КонецФункции

Функция СекретКлиента()
	Возврат ПолучитьПеременнуюСреды("CDEKOS_SECRET");
КонецФункции

// Выполняет получение токена, если старый вышел из строя или не был получен
//
// Параметры:
// 	ПараметрыУчетнойЗаписи - Структура - см. ПараметрыУчетнойЗаписиСДЭК
Процедура ВыполнитьАвторизациюСДЭК(Знач ПараметрыУчетнойЗаписи) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыУчетнойЗаписи.Токен)
		И (ПараметрыУчетнойЗаписи.СрокДействияТокена = Неопределено
			Или ПараметрыУчетнойЗаписи.СрокДействияТокена > ТекущаяДата()) Тогда
		Возврат;
	КонецЕсли;
	
	Ключ = ПараметрыУчетнойЗаписи.Ключ;
	Секрет = ПараметрыУчетнойЗаписи.Секрет;
	ПрефиксApi = ПараметрыУчетнойЗаписи.ПрефиксAPI;
	
	Соединение = Новый HTTPСоединение(ПараметрыУчетнойЗаписи.Адрес,,,,, ТаймаутПоУмолчанию());
	
	Ресурс = СтрШаблон("%1/oauth/token", ПрефиксApi);
	
	Параметры = СтрШаблон("grant_type=%1&client_id=%2&client_secret=%3",
		"client_credentials",
		Ключ,
		Секрет);
		
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-type", "application/x-www-form-urlencoded");
	
	Запрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	Запрос.УстановитьТелоИзСтроки(Параметры);
	
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	Если Ответ.КодСостояния = 200 Тогда
		
		Чтение = Новый ЧтениеJSON;
		Чтение.УстановитьСтроку(Ответ.ПолучитьТелоКакСтроку());
		
		ДанныеОтвета = ПрочитатьJSON(Чтение, Истина);
		Токен = ДанныеОтвета.Получить("access_token");
		Если ЗначениеЗаполнено(Токен) Тогда
			ПараметрыУчетнойЗаписи.Вставить("Токен", Токен);
			ПараметрыУчетнойЗаписи.Вставить("СрокДействияТокена", ТекущаяДата() + ДанныеОтвета["expires_in"]);
			Возврат;
		КонецЕсли;
		
		ВызватьИсключение НСтр("ru='Ошибка получения токена СДЭК';");
		
	КонецЕсли;
	
	ВызватьИсключение Ответ.ПолучитьТелоКакСтроку();
	
КонецПроцедуры

Функция ПолучитьОтветСДЭК(Знач ПараметрыУчетнойЗаписи, Знач Метод, Знач СтруктураЗапроса)
	
	Если Не ЗначениеЗаполнено(ПараметрыУчетнойЗаписи.Токен) Тогда
		ВызватьИсключение НСтр("ru='Не указан токен подключения к СДЭК';");
	КонецЕсли;
	
	ПозицияПробела = СтрНайти(Метод, " ");
	Если ПозицияПробела <> 0 Тогда
		МетодHttp = Лев(Метод, ПозицияПробела - 1);
		АдресРесурса = Сред(Метод, ПозицияПробела + 1);
	Иначе
		МетодHttp = "GET";
		АдресРесурса = Метод;
	КонецЕсли;
	АдресРесурса = СтрШаблон("%1%2", ПараметрыУчетнойЗаписи.ПрефиксApi, АдресРесурса);
	
	Если ТипЗнч(СтруктураЗапроса) = Тип("Структура")
		Или ТипЗнч(СтруктураЗапроса) = Тип("Соответствие") Тогда
		АдресРесурса = ПодставитьПараметры(АдресРесурса, СтруктураЗапроса, (МетодHttp = "GET"));
	КонецЕсли;
	
	Соединение = Новый HTTPСоединение(ПараметрыУчетнойЗаписи.Адрес,,,,, ТаймаутПоУмолчанию());
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Authorization", СтрШаблон("Bearer %1", ПараметрыУчетнойЗаписи.Токен));
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Accept", "application/json");
	
	ЗапросОрдер = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Если МетодHttp = "POST" Тогда
		
		Если СтруктураЗапроса <> Неопределено Тогда
			УстановитьТелоИзСтруктуры(ЗапросОрдер, СтруктураЗапроса);
		КонецЕсли;
		
		ОтветОрдер = Соединение.ОтправитьДляОбработки(ЗапросОрдер);
		
	ИначеЕсли МетодHttp = "GET" Тогда
		
		ОтветОрдер = Соединение.Получить(ЗапросОрдер);
		
	ИначеЕсли МетодHttp = "DELETE" Тогда
		
		ОтветОрдер = Соединение.Удалить(ЗапросОрдер);
		
	ИначеЕсли МетодHttp = "PUT" Тогда
		
		Если СтруктураЗапроса <> Неопределено Тогда
			УстановитьТелоИзСтруктуры(ЗапросОрдер, СтруктураЗапроса);
		КонецЕсли;
		
		ОтветОрдер = Соединение.Записать(ЗапросОрдер);
		
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru='Неверный метод HTTP %1';"), МетодHttp);
	КонецЕсли;
	
	Возврат ОтветОрдер;
	
КонецФункции

Функция ТаймаутПоУмолчанию()
	Возврат 60;
КонецФункции

// Подставляет параметры в строку запроса
//
// Параметры:
// 	АдресРесурса - Строка - исходный адрес ресурса
// 	СтруктураЗапроса - Структура
// 	ПодставлятьПараметрыВURL - Булево - Если Истина, оставшиеся неподставленные параметры будут добавлены как ?param1=value&param2=value...
//
// Возвращаемое значение:
// 	Строка
Функция ПодставитьПараметры(Знач АдресРесурса, Знач СтруктураЗапроса, Знач ПодставлятьПараметрыВURL)
	
	НеобработанныеПараметры = Новый Структура;
	АдресВРЕГ = ВРЕГ(АдресРесурса);
	Для Каждого мКЗ Из СтруктураЗапроса Цикл
		
		ПодстрокаПоиска = СтрШаблон("{%1}", ВРЕГ(мКЗ.Ключ));
		Позиция = СтрНайти(АдресВРЕГ, ПодстрокаПоиска);
		Если Позиция <> 0 Тогда
			
			ПодстрокаПодстановки = КодироватьСтроку(
				ДанныеПараметраДляПодстановки(мКЗ.Значение),
				СпособКодированияСтроки.КодировкаURL);
			
			ПодстрокаЛево = Лев(АдресРесурса, Позиция - 1);
			ПодстрокаПраво = Сред(АдресРесурса, Позиция + СтрДлина(ПодстрокаПоиска));
			АдресРесурса = СтрШаблон("%1%2%3",
				ПодстрокаЛево,
				ПодстрокаПодстановки,
				ПодстрокаПраво);
			АдресВРЕГ = Врег(АдресРесурса);
		Иначе
			НеобработанныеПараметры.Вставить(мКЗ.Ключ, мКЗ.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПодставлятьПараметрыВURL И ЗначениеЗаполнено(НеобработанныеПараметры) Тогда
		
		ПодставляемыеПараметры = Новый Массив;
		Для Каждого мКЗ Из НеобработанныеПараметры Цикл
			ПодставляемыеПараметры.Добавить(СтрШаблон("%1=%2",
				КодироватьСтроку(мКЗ.Ключ, СпособКодированияСтроки.КодировкаURL),
				КодироватьСтроку(ДанныеПараметраДляПодстановки(мКЗ.Значение), СпособКодированияСтроки.КодировкаURL)));
		КонецЦикла;
		АдресРесурса = СтрШаблон("%1?%2", АдресРесурса, СтрСоединить(ПодставляемыеПараметры, "&"));
	КонецЕсли;
	
	Возврат АдресРесурса;
	
КонецФункции

Функция ДанныеПараметраДляПодстановки(Знач Значение)
	
	Если ТипЗнч(Значение) = Тип("Строка") Тогда
		Возврат Значение;
	КонецЕсли;
	
	Если ТипЗнч(Значение) = Тип("Соответствие") Тогда
		
		МассивЗначений = Новый Массив;
		Для Каждого мКЗ Из Значение Цикл
			
			МассивЗначений.Добавить(
				СтрШаблон("%1=%2",
				XmlСтрока(мКЗ.Ключ),
				XmlСтрока(мКЗ.Значение)));
			
		КонецЦикла;
		
		Возврат СтрСоединить(МассивЗначений, ";");
		
	КонецЕсли;
	
	Возврат XmlСтрока(Значение);
	
КонецФункции

Процедура УстановитьТелоИзСтруктуры(Знач Запрос, Знач ТелоСтруктура)
	
	Если ТипЗнч(ТелоСтруктура) = Тип("Строка") Тогда
		ТекстЗапросаВыгрузки = ТелоСтруктура;
	Иначе
		ЗаписьЗапроса = Новый ЗаписьJSON;
		ЗаписьЗапроса.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьЗапроса, ТелоСтруктура);
		
		ТекстЗапросаВыгрузки = ЗаписьЗапроса.Закрыть();
	КонецЕсли;

	Запрос.УстановитьТелоИзСтроки(ТекстЗапросаВыгрузки);
	
КонецПроцедуры

// Возвращает признак запрета на запросы, изменяющие Заказ, Заявки
//
// Возвращаемое значение:
// 	Булево - Истина, если установлен запрет на команды модификации
// 	         Ложь, если запрета нет
Функция ЗащитаОтИзменений() Экспорт
	ЗначениеПеременнойСреды = ПолучитьПеременнуюСреды("CDEKOS_PROTECTION");
	Возврат ЗначениеПеременнойСреды = "1"
		Или ВРЕГ(ЗначениеПеременнойСреды) = "YES"
		Или ВРЕГ(ЗначениеПеременнойСреды) = "Y"
	;
КонецФункции

// Вызывает исключение, если включен защищенный режим
//
// Параметры:
// 	ИмяКоманды - Строка - Имя команды для вывода сообщения
Процедура ПроверитьЗащищенныйРежим(Знач ИмяКоманды) Экспорт

	ТекстСообщения = СтрШаблон(
		НСтр("ru='Команда %1 не доступна в защищенном режиме!';"),
		ИмяКоманды);

	Если ЗащитаОтИзменений() Тогда
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры
