
// Запускает фоновые задания для загрузки услуг сортировки
//
// Параметры:
//  ДанныеИзФайла  - Массив[Строка] - содержимое выгружаемого файла в виде массива строк
//
Процедура ЗапуститьЗагрузкуДанных(ДанныеИзФайла)Экспорт
	//МассивФоновыхЗаданий = Новый Массив;
	ЧастиДанныхФайла = МетодыРаботыСЗагружаемымФайломИЕгоСодержимым.РазбитьДанныеФайлаНаЧасти(ДанныеИзФайла);
	Для Каждого ЧастьДанныхФайла Из ЧастиДанныхФайла Цикл 
		
		
		Ключ = Новый УникальныйИдентификатор;		
		ПараметрыВыполнения = Новый Массив;
		ПараметрыВыполнения.Добавить(ЧастьДанныхФайла);		
		
		ФоновыеЗадания.Выполнить("МетодыРаботыСДокументамиУслугаСортировки.СоздатьДокументыУслугаСортировки", 
				ПараметрыВыполнения, Ключ);		
		//МассивФоновыхЗаданий.Добавить(ФоновоеЗадание);
	КонецЦикла;                                       
	
	//Если МассивФоновыхЗаданий.Количество() > 0 Тогда 
	//	
	//	ФоновыеЗадания.ОжидатьЗавершенияВыполнения(МассивФоновыхЗаданий);
	//КонецЕсли;
КонецПроцедуры // ЗапуститьЗагрузкуДанных()

// Запускает фоновые задания для загрузки услуг сортировки
//
// Параметры:
//  АдресФайлаВоВременномХранилище  - Строка - адрес нахождения файла
//                 во временном хранилище
//
Процедура ВыполнитьЗагрузкуУслугСортировки(АдресФайлаВоВременномХранилище)Экспорт 

	ДанныеИзФайла = МетодыРаботыСЗагружаемымФайломИЕгоСодержимым.ПрочитатьДанныеИзФайлаВоВоременномХранилище(
		АдресФайлаВоВременномХранилище);	
   	ЗапуститьЗагрузкуДанных(ДанныеИзФайла);
КонецПроцедуры // ВыполнитьЗагрузкуУслугСортировки()


// Запускает фоновое задание для загрузки услуг сортировки
//
// Параметры:
//  АдресФайлаВоВременномХранилище  - Строка - адрес нахождения файла
//                 								во временном хранилище
//
Процедура ВыполнитьЗагрузкуУслугСортировкиВФоновомЗадании(АдресФайлаВоВременномХранилище)Экспорт 

	ПараметрыВыполнения = Новый Массив;	
	ПараметрыВыполнения.Добавить(АдресФайлаВоВременномХранилище);			
	ФоновыеЗадания.Выполнить(
		"РегламентныеИФоновыеЗадания.ВыполнитьЗагрузкуУслугСортировки", 
		ПараметрыВыполнения, Новый УникальныйИдентификатор);
КонецПроцедуры // ВыполнитьЗагрузкуУслугСортировкиВФоновомЗадании()


// Запускает фоновое задание удаления документов УслугаСортировки
//
// Параметры:
//
Процедура ВыполнитьУдалениеУслугСортировкиВФоновомЗадание()Экспорт 
	
	ПараметрыВыполнения = Новый Массив;
		ФоновыеЗадания.Выполнить(
			"РегламентныеИФоновыеЗадания.УдалитьВсеДокументыУслугаСортировки", 
			ПараметрыВыполнения);	
КонецПроцедуры // ВыполнитьУдалениеУслугСортировкиВФоновомЗадание()

// Удаляет все документы УслугаСортировки
//
// Параметры:
//
Процедура УдалитьВсеДокументыУслугаСортировки()Экспорт 	
	
	ДокументыДляУдаления = МетодыРаботыСДокументамиУслугаСортировки.ПолучитьNДокументов();
	Пока ДокументыДляУдаления.Количество() > 0 Цикл 
		
		УдалитьОбъекты(ДокументыДляУдаления);
		ДокументыДляУдаления = МетодыРаботыСДокументамиУслугаСортировки.ПолучитьNДокументов();
	КонецЦикла;
КонецПроцедуры // УдалитьВсеДокументыУслугаСортировки()






// Определяет тарифы на все коды обработки
//
// Параметры:
//  ДатаМесяца  - Дата - День месяца, на котрый нужно сформировать тарифы  
//
// Возвращаемое значение:
//   Соответствие   - Тарифы
//
Функция ПолучитьТарифы(ДатаМесяца)
	
	Соответствие = Новый Соответствие;
	
	СреднееКоличествоЕдиницПроходящихЧерезХаб = 
		Документы.УслугаСортировки.ПолучитьСреднееКоличествоЕдиницПроходящихЧерезХабЗаМесяц(ДатаМесяца);
	ТарифНаХабы = РегистрыСведений.ТарифыНаХабы.ПолучитьТарифПоСреднедневномуОбороту(
		СреднееКоличествоЕдиницПроходящихЧерезХаб, ДатаМесяца);
	Соответствие.Вставить(Перечисления.КодыТиповОбработки.Хаб, ТарифНаХабы);
	
	ТарифХранения = РегистрыСведений.ТарифыНаВсеКромеХабов.ПолучитьТарифХранения(ДатаМесяца);
	Соответствие.Вставить(Перечисления.КодыТиповОбработки.Хранение, ТарифХранения);
	
	ТарифНаШины = РегистрыСведений.ТарифыНаВсеКромеХабов.ПолучитьТариф(
			Перечисления.КодыТиповОбработки.Шины, ДатаМесяца);
	Соответствие.Вставить(Перечисления.КодыТиповОбработки.Шины, ТарифНаШины);
	
	ТарифНаКГТ = РегистрыСведений.ТарифыНаВсеКромеХабов.ПолучитьТариф(
			Перечисления.КодыТиповОбработки.Шины, ДатаМесяца);
	Соответствие.Вставить(Перечисления.КодыТиповОбработки.КГТ, ТарифНаКГТ);
	
	ТарифНаМГТ = РегистрыСведений.ТарифыНаВсеКромеХабов.ПолучитьТариф(
			Перечисления.КодыТиповОбработки.Шины, ДатаМесяца);
	Соответствие.Вставить(Перечисления.КодыТиповОбработки.МГТ, ТарифНаМГТ);
	
	Возврат Соответствие;
КонецФункции // ПолучитьТарифы()

// Рассчитывает часть документов (заполняет СтоимостьХранения и СтоимостьСортировки)
//
// Параметры:
//  Корзина  - Массив - Список документов для рассчета
//  ДатаМесяца  - Дата - дата месяца для расчета тарифов
//
Процедура ВыполнитьРасчетЗаМесяцВФоновомЗадании(Корзина, ДатаМесяца)Экспорт 
	КоличествоПопыток = 5;	
	
	Тарифы = ПолучитьТарифы(ДатаМесяца);
	Для Каждого УслугаСортировки Из Корзина Цикл 
		
			
		Счетчик = 1;
		Пока Не МетодыРаботыСДокументамиУслугаСортировки.РассчитатьДокументУслугаСортировки(
			УслугаСортировки, Тарифы) Цикл 
			
			Если Счетчик = КоличествоПопыток Тогда 
				
				Прервать;
			КонецЕсли;
			Счетчик = Счетчик + 1;			
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры // ВыполнитьРасчетЗаМесяцВФоновомЗадании()

// Запускает механизм расчета документов за месяц
//
// Параметры:  
//  ДатаМесяца  - Дата - дата месяца для расчета тарифов
//
Процедура ВыполнитьРасчетЗаМесяц(ДатаМесяца)Экспорт 
	
	ВыборкаДокументовЗаМесяц = Документы.УслугаСортировки.ПолучитьВыборкуДокументовЗаМесяц(ДатаМесяца);
	Корзины = МетодыРаботыСДокументамиУслугаСортировки.РазбитьВыборкуДокументовНаЧасти(ВыборкаДокументовЗаМесяц);
	Для Каждого Корзина Из Корзины Цикл 
		
		Ключ = Новый УникальныйИдентификатор;
		
		ПараметрыВыполнения = Новый Массив;
		ПараметрыВыполнения.Добавить(Корзина);
		ПараметрыВыполнения.Добавить(ДатаМесяца);
		ФоновыеЗадания.Выполнить(
			"РегламентныеИФоновыеЗадания.ВыполнитьРасчетЗаМесяцВФоновомЗадании", 
			ПараметрыВыполнения, Ключ);
	КонецЦикла;
КонецПроцедуры // ВыполнитьРасчетЗаМесяц()