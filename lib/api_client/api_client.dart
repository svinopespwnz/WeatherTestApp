import 'dart:convert';

import 'package:weather_test_app/configuration/api_config.dart';
import 'package:weather_test_app/models/daily_forecast.dart';
import 'package:http/http.dart' as http;
//реализуем интерфейс Exception для того, чтобы при ошибке использовать свой
// класс с переопределенным методом
class ApiException implements Exception{
  String message;
  ApiException(this.message);
@override
  String toString() {

  return "$message";
  }

}
class ApiClient {
  Future<DailyForecast> ApiRequestByCityName({required String cityName}) async {
    final queryParameters = {
      'q': cityName,
      'appId': ApiConfiguration.APP_ID,
      'units': 'metric',
      'lang':'ru'
    };
    final url = Uri.parse(ApiConfiguration.HOST)
      .replace(queryParameters: queryParameters);// собирается url из частей

      final response = await http.get(url); //GET запрос к API
    if(response.statusCode==200)
      return DailyForecast.fromJson(jsonDecode(response.body));//возвращаем
      // объект при помощи именованного конструктора,
      // куда передается body из ответа в виде Map
    else throw ApiException('Ошибка получения данных'); // иначе выкидываем ошибку
  }
}
