
Процедура ВывестиОтвет(Знач Ответ) Экспорт

	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, " ");
	ЗаписьОтвета = Новый ЗаписьJSON;
	ЗаписьОтвета.УстановитьСтроку(ПараметрыЗаписиJSON);

	ЗаписатьJSON(ЗаписьОтвета, Ответ);

	ТекстСообщения = ЗаписьОтвета.Закрыть();
	Сообщить(ТекстСообщения);

КонецПроцедуры
