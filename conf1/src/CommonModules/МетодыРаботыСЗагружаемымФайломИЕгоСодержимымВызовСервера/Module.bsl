#Область ПрограммныйИнтерфейс

// Содержимое текстового файла помещает в массив строк
//
// Параметры:
//  АдресФайлаВоВременномХранилище  - Строка - Полный путь к файлу  
//
// Возвращаемое значение:
//   Массив из Строка  - Содержимое текстового файла в виде массива
//
Функция ПрочитатьДанныеИзФайлаВоВоременномХранилище(АдресФайлаВоВременномХранилище)Экспорт 
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("csv");
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);	
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	ДанныеФайла = ПрочитатьДанныеИзФайла(ИмяВременногоФайла);
	
	УдалитьФайлы(ИмяВременногоФайла);
	УдалитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
	
	Возврат СтрРазделить(ДанныеФайла, Символы.ПС, Ложь);
КонецФункции // ПрочитатьДанныеИзФайлаВоВоременномХранилище()

// Разбивает массив строк на части
//
// Параметры:
//  ДанныеИзФайла  - Массив из Строка - Полный путь к файлу  
//  РазмерКорзины  - Число - количество элементов каждой части
//
// Возвращаемое значение:
//   Массив из Строка  - Список списков строк загружаемого файла (матрица из строк)
//
Функция РазбитьДанныеФайлаНаЧасти(ДанныеИзФайла, РазмерКорзины = 10000)Экспорт
	СписокКорзин = Новый Массив;
	СчетчикСтрокКорзины = 0;
		
	СчетчикСтрок = 1;Корзина = Новый Массив;
	Пока СчетчикСтрок <= ДанныеИзФайла.Количество() - 1 Цикл 
		
		Если СчетчикСтрокКорзины = РазмерКорзины Тогда 
						
			СписокКорзин.Добавить(Корзина);
			Корзина = Новый Массив;
			СчетчикСтрокКорзины = 0;
		КонецЕсли;
		
		Корзина.Добавить(ДанныеИзФайла[СчетчикСтрок]);
		
		СчетчикСтрок = СчетчикСтрок + 1;
		СчетчикСтрокКорзины = СчетчикСтрокКорзины + 1;
	КонецЦикла;
	
	Если Корзина.Количество() > 0 Тогда 
		
		СписокКорзин.Добавить(Корзина);
	КонецЕсли;	
	
	Возврат СписокКорзин;
КонецФункции // РазбитьДанныеФайлаНаЧасти()

// Разбивает строку на части, части конвертирует в значения для
// заполнения ими нового документа 
//
// Параметры:
//  Строка  - Строка - Очередная строка из загружаемого файла    
//
// Возвращаемое значение:
//   Структура  - Значения для заполнения документа
//
Функция ПолучитьДанныеДляСозданиеДокумента(Строка)Экспорт
	
	Слова = СтрРазделить(Строка, ",", Истина);
	Структура = Новый Структура;
	Структура.Вставить("НомерГрузовогоМеста", СтрЗаменить(СокрЛП(Слова[2]), Символ(34), ""));
	Структура.Вставить("ДатаПрибытия", Дата(СтрЗаменить(СокрЛП(Слова[6]), "-", "") + "000000"));
	Структура.Вставить("ДатаУбытия", Дата(СтрЗаменить(СокрЛП(Слова[0]), "-", "") + "000000"));
	Структура.Вставить("КодТипаОбработки", Перечисления.КодыТиповОбработки[СокрЛП(Слова[8])]);
	Структура.Вставить("ОтпСклМс", Лев(СокрЛП(Слова[5]), 4));
	//Структура.Вставить("Дата", Дата(СтрЗаменить(СокрЛП(Слова[6]), "-", "") + СтрЗаменить(СокрЛП(Слова[7]), ":", "")));
	Структура.Вставить("Дата", ТекущаяДатаСеанса());
	
	//@skip-check constructor-function-return-section
	Возврат Структура;
КонецФункции // ПолучитьДанныеДляСозданиеДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Считывает данные из текстового файла
//
// Параметры:
//  ИмяФайла  - Строка - Полный путь к файлу  
//
// Возвращаемое значение:
//   Строка   - Содержимое текстового файла
//
Функция ПрочитатьДанныеИзФайла(ИмяФайла)
		
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла, КодировкаТекста.UTF8);
	Возврат ТекстовыйДокумент.ПолучитьТекст()
КонецФункции // ПрочитатьДанныеИзФайла()

#КонецОбласти