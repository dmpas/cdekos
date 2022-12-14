#Использовать "../../core"

Процедура ОписаниеКоманды(Знач КомандаПриложения) Экспорт
	
	КомандаПриложения.Опция("m im", "", "Номер заказа интернет-магазина");

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт

	НомерЗаказа = КомандаПриложения.ЗначениеОпции("im");

	Заказ = Новый Order;
	Если ЗначениеЗаполнено(НомерЗаказа) Тогда
		Заказ.type = ТипыЗаказов.ИнтернетМагазин;
		Заказ.number = НомерЗаказа;
	Иначе
		Заказ.type = ТипыЗаказов.Доставка;
	КонецЕсли;

	ПозицияШаблон = Новый OrderPackageItem;
	ПозицияШаблон.name = "Товар1";
	ПозицияШаблон.amount = 1;
	ПозицияШаблон.cost = 20;
	
	УпаковкаШаблон = Новый OrderPackage;
	УпаковкаШаблон.items.Добавить(ПозицияШаблон);
	Заказ.packages.Добавить(УпаковкаШаблон);

	ОбщегоНазначенияСДЭК.ВывестиОтвет(Сериализатор.Записать(Заказ));

КонецПроцедуры
