import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test_app/weather_repository/weather_repository.dart';

import 'widgets/first_screen.dart';

void main() {
  runApp(MyApp(
    weatherRepository: WeatherRepository(),//создаем репозиторий, с помощью
    // которого будем получать данные
  ));
}

class MyApp extends StatelessWidget {

  final WeatherRepository _weatherRepository;

  const MyApp({Key? key, required weatherRepository})
      : _weatherRepository = weatherRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(//внедряем репозиторий
      value: _weatherRepository,
      child: const MyAppView(),
    );
  }
}

class MyAppView extends StatelessWidget {
  const MyAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FirstScreen(),
    );
  }
}
