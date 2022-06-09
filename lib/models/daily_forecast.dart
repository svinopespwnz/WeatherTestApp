import 'package:json_annotation/json_annotation.dart';
import 'package:weather_test_app/configuration/api_config.dart';

part 'daily_forecast.g.dart';

/*
Исходя из примера ответа, были создана классы, представляющие собой части
для представления ответа. При помощи пакета json_serializable был
сгенерирован файл, в котором происходит сериализация
*/
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DailyForecast {
  final City city;
  final String cod;
  final double message;
  final int cnt;
  final List<ForecastList> list;

  DailyForecast(
      {required this.city,
      required this.cod,
      required this.message,
      required this.cnt,
      required this.list});
  factory DailyForecast.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastFromJson(json);
  Map<String, dynamic> toJson() => _$DailyForecastToJson(this);

  DailyForecast copyWith({
    City? city,
    String? cod,
    double? message,
    int? cnt,
    List<ForecastList>? list,
  }) {
    return DailyForecast(
      city: city ?? this.city,
      cod: cod ?? this.cod,
      message: message ?? this.message,
      cnt: cnt ?? this.cnt,
      list: list ?? this.list,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class City {
  final int id;
  final String name;
  final Coord coord;
  final String country;
  final int population;
  final int timezone;

  City(
      {required this.id,
      required this.name,
      required this.coord,
      required this.country,
      required this.population,
      required this.timezone});
  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Coord {
  final double lon;
  final double lat;

  Coord({required this.lon, required this.lat});
  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
  Map<String, dynamic> toJson() => _$CoordToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ForecastList {
  final int dt;
  final int sunrise;
  final int sunset;
  final Temp temp;
  final FeelsLike feelsLike;
  final int pressure;
  final int humidity;
  final List<Weather> weather;
  final double speed;
  final int deg;
  final double gust;
  final int clouds;
  final double? pop;
  final double? rain;

  ForecastList(
      {required this.dt,
      required this.sunrise,
      required this.sunset,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.weather,
      required this.speed,
      required this.deg,
      required this.gust,
      required this.clouds,
      required this.pop,
      required this.rain});
  factory ForecastList.fromJson(Map<String, dynamic> json) =>
      _$ForecastListFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastListToJson(this);
  String getIcon(int index) {
    return ApiConfiguration.IMAGE_URL + weather[0].icon + '.png';// возвращает url иконки
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Temp {
  final double day;
  final double min;
  final double max;
  final double night;
  final double eve;
  final double morn;

  Temp(
      {required this.day,
      required this.min,
      required this.max,
      required this.night,
      required this.eve,
      required this.morn});
  factory Temp.fromJson(Map<String, dynamic> json) => _$TempFromJson(json);
  Map<String, dynamic> toJson() => _$TempToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FeelsLike {
  final double day;
  final double night;
  final double eve;
  final double morn;

  FeelsLike(
      {required this.day,
      required this.night,
      required this.eve,
      required this.morn});
  factory FeelsLike.fromJson(Map<String, dynamic> json) =>
      _$FeelsLikeFromJson(json);
  Map<String, dynamic> toJson() => _$FeelsLikeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather(
      {required this.id,
      required this.main,
      required this.description,
      required this.icon});
  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
