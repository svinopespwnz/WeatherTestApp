import 'package:intl/intl.dart';
//форматирование даты к виду День недели
abstract class FormatDate {
  static String getFormattedDate(DateTime dateTime) {
    return DateFormat.EEEE('ru_RU').format(dateTime);
  }
}
