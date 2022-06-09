import 'package:bloc/bloc.dart';
import 'package:weather_test_app/api_client/api_client.dart';
import 'package:weather_test_app/models/daily_forecast.dart';
import 'package:weather_test_app/weather_repository/weather_repository.dart';

enum ForecastStatus {
  initial,
  loading,
  success,
  failure
} //перечисление статуса загрузки

class ForecastState {
  final ForecastStatus status;
  final DailyForecast? forecast;
  final String? exception;
  final List<ForecastList>? sortedList;
  ForecastState(
      {this.status = ForecastStatus.initial,
      this.forecast,
      this.exception,
      this.sortedList});

  ForecastState copyWith({
    ForecastStatus? status,
    DailyForecast? forecast,
    String? exception,
    List<ForecastList>? sortedList,
  }) {
    return ForecastState(
      status: status ?? this.status,
      forecast: forecast ?? this.forecast,
      exception: exception ?? this.exception,
      sortedList: sortedList ?? this.sortedList,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForecastState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          forecast == other.forecast &&
          exception == other.exception &&
          sortedList == other.sortedList;

  @override
  int get hashCode =>
      status.hashCode ^
      forecast.hashCode ^
      exception.hashCode ^
      sortedList.hashCode;
}

class ForecastCubit extends Cubit<ForecastState> {
  final WeatherRepository _weatherRepository;

  ForecastCubit(this._weatherRepository) : super(ForecastState());
  Future<void> fetchForecast(String? city) async {
    if (city == null || city.isEmpty) {
      emit(state.copyWith(status: ForecastStatus.initial));//если строка пустая, то новое состояние со статусом initial
      return;
    }
    emit(state.copyWith(status: ForecastStatus.loading));
    try {
      final forecast = await _weatherRepository.getForecast(city);// запрос к Api

      emit(state.copyWith(status: ForecastStatus.success, forecast: forecast));//если без ошибок, то состояние success и передача данных
    } on ApiException catch (e) {//при ошибке сотояние failure и передача сообщения ошибки
      emit(state.copyWith(
          status: ForecastStatus.failure, exception: e.toString()));
    }
  }

  void sortForecast() {
    final forecastList = state.forecast!.list.take(3).toList();//получение List из 3 ForecastList
    forecastList.sort((a, b) => a.temp.day.compareTo(b.temp.day));//сортировка по возрастанию температуры
    emit(state.copyWith(sortedList: forecastList));//в новое состояние отсортированный List
  }
}
