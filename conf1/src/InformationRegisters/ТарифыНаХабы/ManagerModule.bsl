#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	
#Область ПрограммныйИнтерфейс

// Возвращает таблицу порогов действующих тарифов
//
// Параметры:
//  МесяцСреза  - Дата - Любая дата месяца из корого нужно получить тариф на Хаб 
//
// Возвращаемое значение:
//   ТаблицаЗначений   - таблица действующих тарифов на хабы
//
Функция ПолучитьТаблицуДействующихПороговНаХабы(МесяцСреза = Неопределено)Экспорт 

	Если МесяцСреза = Неопределено Тогда 
		
		МесяцСреза = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;                                       
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПорогиУстановкиТарифовНаХабыПороги.НижняяГраница КАК НижняяГраница,
	|	ПорогиУстановкиТарифовНаХабыПороги.Тариф КАК Тариф
	|ИЗ
	|	Справочник.ВариантыПороговУстановкиТарифовНаХабы.Пороги КАК ПорогиУстановкиТарифовНаХабыПороги
	|ГДЕ
	|	ПорогиУстановкиТарифовНаХабыПороги.Ссылка В
	|			(ВЫБРАТЬ
	|				ТарифыНаХабыСрезПоследних.Порог КАК Порог
	|			ИЗ
	|				РегистрСведений.ТарифыНаХабы.СрезПоследних(&МесяцСреза, ) КАК ТарифыНаХабыСрезПоследних)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НижняяГраница
	|АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("МесяцСреза", МесяцСреза);
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить();
КонецФункции // ПолучитьТаблицуДействующихПороговНаХабы()


// Получает действующий тариф на Хаб на заданную дату (месяц)
//
// Параметры:
//  СреднедневнойОборот  - Число - Среднедневное количество единиц, проходящий через хаб 
//  						(КоличетсвоНаХабеЗаМесяц/КоличествоКалендарныхДней)
//  МесяцСреза  - Дата - Любая дата месяца из корого нужно получить тариф на Хаб
//
// Возвращаемое значение:
//   Число   - значение действующего тарифа
//
Функция ПолучитьТарифПоСреднедневномуОбороту(СреднедневнойОборот, МесяцСреза = Неопределено)Экспорт
	
	Если МесяцСреза = Неопределено Тогда 
		
		МесяцСреза = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;                                       
	
	Тариф = 0;
	ТаблицаДействующихПороговНаХабы = ПолучитьТаблицуДействующихПороговНаХабы(МесяцСреза);
	Для Каждого ТекСтрокаТаблициДействующихПороговНаХабы Из ТаблицаДействующихПороговНаХабы Цикл 
		
		Если СреднедневнойОборот > ТекСтрокаТаблициДействующихПороговНаХабы.НижняяГраница Тогда 
			
			Тариф = ТекСтрокаТаблициДействующихПороговНаХабы.Тариф;
		Иначе
			Прервать;
		КонецЕсли;		
	КонецЦикла;
	
	Возврат Тариф;
КонецФункции // ПолучитьТарифПоСреднедневномуОбороту()


// Получает таблицу действующих тарифов покаждому Хабу на заданную дату (месяц)
//
// Параметры:
//  ТаблицаСреднедневныхОборотов  - ТаблицаЗначений - Среднедневные значения количество единиц, проходящих через хаб 
//  						(КоличетсвоНаХабеЗаМесяц/КоличествоКалендарныхДней)
//  МесяцСреза  - Дата - Любая дата месяца из корого нужно получить тариф на Хаб
//
// Возвращаемое значение:
//   ТаблицаЗначений   - значение действующего тарифа по каждому хабу
//
Функция ПолучитьТарифыПоСреднедневномуОбороту(ТаблицаСреднедневныхОборотов, МесяцСреза = Неопределено)Экспорт
	
	Если МесяцСреза = Неопределено Тогда 
		
		МесяцСреза = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;                  
	
	ТаблицаДействующихПороговНаХабы = ПолучитьТаблицуДействующихПороговНаХабы(МесяцСреза);
	
	ТарифыНаХабы = Новый ТаблицаЗначений;
	ТарифыНаХабы.Колонки.Добавить("ОтпСклМс", Новый ОписаниеТипов("Строка", ,
											  Новый КвалификаторыСтроки(4, ДопустимаяДлина.Переменная)));
	ТарифыНаХабы.Колонки.Добавить("Тариф", Новый ОписаниеТипов("Число",
										   Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный)));
	
	Для Каждого ТекСтрокаТаблицыСреднедневныхОборотов Из ТаблицаСреднедневныхОборотов Цикл 
		
		НоваяСтрокаТаблицыТарифов = ТарифыНаХабы.Добавить();
		НоваяСтрокаТаблицыТарифов.ОтпСклМс = ТекСтрокаТаблицыСреднедневныхОборотов.ОтпСклМс;
		НоваяСтрокаТаблицыТарифов.Тариф = 0;
		
		Для Каждого ТекСтрокаТаблициДействующихПороговНаХабы Из ТаблицаДействующихПороговНаХабы Цикл 
						
			Если ТекСтрокаТаблицыСреднедневныхОборотов.СреднееКоличествоЕдиницПроходящихЧерезХабЗаМесяц > 
					ТекСтрокаТаблициДействующихПороговНаХабы.НижняяГраница Тогда 
				
				НоваяСтрокаТаблицыТарифов.Тариф = ТекСтрокаТаблициДействующихПороговНаХабы.Тариф;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;         
	ТарифыНаХабы.Индексы.Добавить("ОтпСклМс");
	
	Возврат ТарифыНаХабы;
КонецФункции // ПолучитьТарифыПоСреднедневномуОбороту()


// Получает действующий вариант порогов для Хаб на заданную дату (месяц)
//
// Параметры:
//  МесяцСреза  - Дата - Любая дата месяца из корого нужно получить тариф на Хаб
//
// Возвращаемое значение:
//   СправочникСсылка.ВариантыПороговУстановкиТарифовНаХабы, неопределено   - значение действующего порога
//
Функция ПолучитьДействующийВариантПорогов(МесяцСреза = Неопределено)Экспорт
	
	Если МесяцСреза = Неопределено Тогда 
		
		МесяцСреза = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;                                       
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТарифыНаХабыСрезПоследних.Порог КАК Порог
	|ИЗ
	|	РегистрСведений.ТарифыНаХабы.СрезПоследних(&МесяцСреза, ) КАК ТарифыНаХабыСрезПоследних";
		
	Запрос.УстановитьПараметр("МесяцСреза", МесяцСреза); 
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Порог;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции // ПолучитьДействующийВариантПорогов()

#КонецОбласти

#КонецЕсли