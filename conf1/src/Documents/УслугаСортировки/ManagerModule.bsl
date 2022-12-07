#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает выборку документов за месяц указанной даты
//
// Параметры:
// ДатаМесяца  - Дата - Дата за месяк которой нужно получить выборку долкументов
//
// Возвращаемое значение:
//   	ВыборкаИзРезультатаЗапроса.   - <описание возвращаемого значения>
//
Функция ПолучитьВыборкуДокументовЗаМесяц(ДатаМесяца)Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписокУслугаСортировки.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.УслугаСортировки КАК СписокУслугаСортировки
	|ГДЕ
	|	СписокУслугаСортировки.ДатаУбытия МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НЕ СписокУслугаСортировки.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокУслугаСортировки.ДатаУбытия
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ДатаМесяца));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ДатаМесяца));
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выбрать();
КонецФункции // ПолучитьВыборкуДокументовЗамесяц()

// Возвращает среднее количество единиц проходящих через Хаб за месяц
//
// Параметры:
// ДатаМесяца  - Дата - Дата за месяк которой нужно получить выборку долкументов
//
// Возвращаемое значение: 
// 		Число - среднее количество единиц проходящих через Хаб за месяц
//
Функция ПолучитьСреднееКоличествоЕдиницПроходящихЧерезХабЗаМесяц(ДатаМесяца)Экспорт 
	
	ОдинДень = 86400;
	КоличествоКалендарныхДней = (НачалоДня(КонецМесяца(ДатаМесяца)) - НачалоМесяца(ДатаМесяца)) / ОдинДень;
	КоличествоНаХабеЗаМесяц = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СписокУслугаСортировки.Ссылка) КАК КоличествоНаХабеЗаМесяц
	|ИЗ
	|	Документ.УслугаСортировки КАК СписокУслугаСортировки
	|ГДЕ
	|	СписокУслугаСортировки.ДатаУбытия МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НЕ СписокУслугаСортировки.ПометкаУдаления
	|	И СписокУслугаСортировки.КодТипаОбработки = ЗНАЧЕНИЕ(Перечисление.КодыТиповОбработки.Хаб)";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ДатаМесяца));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ДатаМесяца));	
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда 
		
		КоличествоНаХабеЗаМесяц = Выборка.КоличествоНаХабеЗаМесяц;
	КонецЕсли;                                                    
	
	Возврат Цел(КоличествоНаХабеЗаМесяц / КоличествоКалендарныхДней);	
КонецФункции // ПолучитьСреднееКоличествоЕдиницПроходящихЧерезХаб()

// Возвращает таблицу средних количеств единиц проходящих через Хаб за месяц, по каждому хабу
//
// Параметры:
// ДатаМесяца  - Дата - Дата за месяк которой нужно получить выборку долкументов
//
// Возвращаемое значение: 
// 		ТаблицаЗначений   - среднее количество единиц проходящих через Хаб за месяц по каждому хабу
//
Функция ПолучитьТаблицуСреднихКоличествЕдиницПроходящихЧерезХабЗаМесяц(ДатаМесяца)Экспорт 
	
	ОдинДень = 86400;
	КоличествоКалендарныхДней = (НачалоДня(КонецМесяца(ДатаМесяца)) - НачалоМесяца(ДатаМесяца)) / ОдинДень;
	КоличествоНаХабеЗаМесяц = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписокУслугаСортировки.ОтпСклМс КАК ОтпСклМс,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СписокУслугаСортировки.Ссылка) КАК КоличествоНаХабеЗаМесяц
	|ПОМЕСТИТЬ втОборотыУслугСортировки
	|ИЗ
	|	Документ.УслугаСортировки КАК СписокУслугаСортировки
	|ГДЕ
	|	СписокУслугаСортировки.ДатаУбытия МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НЕ СписокУслугаСортировки.ПометкаУдаления
	|	И СписокУслугаСортировки.КодТипаОбработки = ЗНАЧЕНИЕ(Перечисление.КодыТиповОбработки.Хаб)
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокУслугаСортировки.ОтпСклМс
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОборотыУслугСортировки.ОтпСклМс КАК ОтпСклМс,
	|	втОборотыУслугСортировки.КоличествоНаХабеЗаМесяц КАК КоличествоНаХабеЗаМесяц,
	|	ЦЕЛ(втОборотыУслугСортировки.КоличествоНаХабеЗаМесяц / &КоличествоКалендарныхДней) КАК СреднееКоличествоЕдиницПроходящихЧерезХабЗаМесяц
	|ИЗ
	|	втОборотыУслугСортировки КАК втОборотыУслугСортировки";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ДатаМесяца));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ДатаМесяца));
	Запрос.УстановитьПараметр("КоличествоКалендарныхДней", КоличествоКалендарныхДней);
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить();
КонецФункции // ПолучитьТаблицуСреднихКоличествЕдиницПроходящихЧерезХабЗаМесяц()

// Возвращает количество дней хранения груза
//
// Параметры:
//  УслугаСортировки  - ДокументСсылка.УслугаСортировки - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение: 
// 		Число   - Количество дней хранения груза
//
Функция ПолучитьОбщееКоличествоДнейХраненияГруза(УслугаСортировки)Экспорт 
	
	ОдинДень = 86400;
	КоличествоДнейХраненияГруза = (НачалоДня(УслугаСортировки.ДатаУбытия) - НачалоДня(УслугаСортировки.ДатаПрибытия)) / ОдинДень; 
	Возврат Цел(КоличествоДнейХраненияГруза);
КонецФункции // ПолучитьОбщееКоличествоДнейХраненияГруза(УслугаСортировки)

// Возвращает количество дней хранения груза (отдельно рабочие дни и выходные)
//
// Параметры:
//  УслугаСортировки  - ДокументСсылка.УслугаСортировки - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение: 
// 		Структура   - Количество дней хранения груза
//
Функция ПолучитьСведенияПоДнямХраненияГруза(УслугаСортировки)Экспорт 
			
	СведенияПоДнямХраненияГруза = Новый Структура("КоличествоРабочихДней, КоличествоВыходныхДней", 0, 0);	
	
	ОдинДень = 86400;
	ВременнаяДата = УслугаСортировки.ДатаПрибытия;
	Пока ВременнаяДата < УслугаСортировки.ДатаУбытия Цикл 
				
		Если РегистрыСведений.ПроизводственныйКалендарь.ЭтоВыходной(ВременнаяДата) Тогда 			
			
			СведенияПоДнямХраненияГруза.КоличествоВыходныхДней = СведенияПоДнямХраненияГруза.КоличествоВыходныхДней + 1;
		Иначе                                             
			
			СведенияПоДнямХраненияГруза.КоличествоРабочихДней = СведенияПоДнямХраненияГруза.КоличествоРабочихДней + 1;
		КонецЕсли;
		
		ВременнаяДата = ВременнаяДата + ОдинДень;
	КонецЦикла;
	
	//@skip-check constructor-function-return-section
	Возврат СведенияПоДнямХраненияГруза;
КонецФункции // ПолучитьСведенияПоДнямХраненияГруза(УслугаСортировки)

#КонецОбласти

#КонецЕсли