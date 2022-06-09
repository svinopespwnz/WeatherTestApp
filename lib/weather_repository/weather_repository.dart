import 'package:weather_test_app/api_client/api_client.dart';
import 'package:weather_test_app/models/daily_forecast.dart';

class WeatherRepository {
  final ApiClient _apiClient;

  WeatherRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(); //создаем или используем уже
  // созданный ApiClient для запроса к API
  Future<DailyForecast> getForecast(String cityName)async{
    final forecast= await _apiClient.ApiRequestByCityName(cityName: cityName);
    // обращаемся к ApiClient, который вернет объект типа Future<DailyForecast>,
    // поэтому используем async await
    return forecast;
  }
}
