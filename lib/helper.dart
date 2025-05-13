import 'package:intl/intl.dart';

class Helper {
  static String formatDate(String? date, String format, {String locale = "id_ID"}) {
    String now = DateTime.now().toIso8601String();
    DateTime dateTime = DateTime.parse(date ?? now);
    return DateFormat(format, locale).format(dateTime);
  }
}