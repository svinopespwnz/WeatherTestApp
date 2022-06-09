import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test_app/bloc/bloc.dart';
import 'package:weather_test_app/configuration/text_styles.dart';
import 'package:weather_test_app/widgets/third_screen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);
  //Создание второго экрана и внедрение уже созданного Cubit
  static Route route(ForecastCubit forecastCubit) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
              value: forecastCubit,
              child:const SecondScreen(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastCubit, ForecastState>(builder: (context, state) {
      switch (state.status) {// отображение разных экранов, в зависимости от статуса
        case ForecastStatus.success:
          return const SecondScreenViewSuccess();

        case ForecastStatus.initial:
          return const SecondScreenViewEmpty();
        case ForecastStatus.loading:
          return const SecondScreenViewLoading();
        case ForecastStatus.failure:
          return const  SecondScreenViewFail();
      }
    });
  }
}

class SecondScreenViewSuccess extends StatelessWidget {
  const SecondScreenViewSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForecastCubit>();//получение Cubit по контексту
    final forecast = cubit.state.forecast;
    final forecastList = forecast!.list[0];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Center(
              child: Text(forecast.city.name + ', ' + forecast.city.country)),// отображение данных из состояния Cubit
          actions: [IconButton(onPressed: () {
            cubit.sortForecast();// сортировка данных о погоде по возрастанию температуры
            Navigator.of(context).push<void>(
              ThirdScreen.route(context.read<ForecastCubit>()));}, icon: Icon(Icons.list))],//навигация на 3 экран
        ),
        body: Container(
            child: DecoratedBox(
          decoration:const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Text(
                  forecastList.temp.day.toStringAsFixed(0) + '°C',
                  style: AppTextStyle.degreeText,
                ),
              ),
              FittedBox(fit: BoxFit.fitWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      forecastList.weather[0].description.toCapitalized(),
                      style: AppTextStyle.descriptionText,
                    ),
                    Image.network(forecastList.getIcon(0))// отображние иконки погоды по url
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Подробности',
                        style: AppTextStyle.dividerText,
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 1, color: Colors.grey))
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DetailsCard(
                      data:
                          forecastList.feelsLike.day.toStringAsFixed(0) + '°C',
                      text: 'Температура по ощущениям',
                      icon:const  Icon(
                        Icons.thermostat,
                        color: Colors.white54,
                      )),
                  DetailsCard(
                    data: forecastList.humidity.toString() + '%',
                    text: 'Влажность',
                    icon: const Icon(Icons.water_drop, color: Colors.white54),
                  ),
                  DetailsCard(
                    data: forecastList.speed.toString() + ' м/с',
                    text: 'Ветер',
                    icon: const Icon(Icons.air, color: Colors.white54),
                  )
                ],
              )
            ],
          )),
        )));
  }
}

class SecondScreenViewFail extends StatelessWidget {
  const SecondScreenViewFail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
            backgroundColor: Colors.deepPurple, title: Center(child: Text(''))),
        body:const  SnackBarView());
  }
}

class SnackBarView extends StatelessWidget {
  const SnackBarView({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnackBar(context,context.read<ForecastCubit>().state.exception!);// отображение SnackBar после того, как завершится layout, иначе была бы ошибка
    });

    return Container(
        constraints: BoxConstraints.expand(),
        child: DecoratedBox(
            decoration:const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Center(
              child: Text(
                'Ошибка получения данных!',
                style: AppTextStyle.descriptionText,
              ),
            )));
  }

  void showSnackBar(BuildContext context,String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));// вызов SnackBar
  }
}

class SecondScreenViewEmpty extends StatelessWidget {
  const SecondScreenViewEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurple, title: Center(child: Text(''))),
        body: Container(
            constraints: BoxConstraints.expand(),
            child: DecoratedBox(
                decoration:const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.indigo],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                child: Center(
                  child: Text(
                    'Выберите город!',
                    style: AppTextStyle.descriptionText,
                  ),
                ))));
  }
}

class SecondScreenViewLoading extends StatelessWidget {
  const SecondScreenViewLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurple, title: Center(child: Text(''))),
        body: Container(
            constraints: BoxConstraints.expand(),
            child: DecoratedBox(
                decoration:const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.indigo],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                child:const CircularProgressIndicator(
                  color: Colors.purple,
                ))));
  }
}

class DetailsCard extends StatelessWidget {
  const DetailsCard(
      {Key? key, required this.icon, required this.text, required this.data})
      : super(key: key);
  final Icon icon;
  final String text;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            icon,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: AppTextStyle.dividerText,
              ),
            )
          ]),
          Text(
            data,
            style: AppTextStyle.dividerText,
          )
        ],
      ),
    );
  }
}
// расширение для перевода первой буквы к заглавной
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
