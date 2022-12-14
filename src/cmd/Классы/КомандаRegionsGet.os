#Использовать "../../core"

Процедура ОписаниеКоманды(Знач КомандаПриложения) Экспорт
	
	КомандаПриложения.Опция("c country", "", НСтр("ru='Коды стран в формате ISO_3166-1_alpha-2 (RU,LT,TR))';"));

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт

	КодСтраны = КомандаПриложения.ЗначениеОпции("country");

	СтруктураЗапроса = Новый Структура;
	Если ЗначениеЗаполнено(КодСтраны) Тогда
		СтруктураЗапроса.Вставить("country_codes", КодСтраны);
	КонецЕсли;

	АдресРесурса = "GET /location/regions";

	Ответ = СДЭК.ВыполнитьЗапросСДЭК(АдресРесурса,
		СтруктураЗапроса,
		СДЭК.ПараметрыУчетнойЗаписиСДЭК());

	ОбщегоНазначенияСДЭК.ВывестиОтвет(Ответ);

КонецПроцедуры

