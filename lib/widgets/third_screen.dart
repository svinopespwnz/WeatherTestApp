import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test_app/bloc/bloc.dart';
import 'package:weather_test_app/configuration/format_date.dart';
import 'package:weather_test_app/configuration/text_styles.dart';
import 'package:weather_test_app/widgets/second_screen.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);
  //Создание третьего экрана и внедрение уже созданного Cubit
  static Route route(ForecastCubit forecastCubit) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
              value: forecastCubit,
              child:const ThirdScreen(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return const ThirdScreenView();
  }
}

class ThirdScreenView extends StatelessWidget {
  const ThirdScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forecast = context.read<ForecastCubit>().state.forecast;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(forecast!.city.name + ', ' + forecast.city.country),
          centerTitle: true,
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
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return  DailyCard(index: index);
                        })))));
  }
}

class DailyCard extends StatelessWidget {
  const DailyCard({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    final forecast = context
        .read<ForecastCubit>()
        .state
        .sortedList!; //получение отсортированного листа из состояния
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(forecast[index].getIcon(index)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    FormatDate.getFormattedDate(
                            DateTime.fromMillisecondsSinceEpoch(
                                forecast[index].dt *
                                    1000)) //перевод даты в нужный вид
                        .toCapitalized(),
                    style: AppTextStyle.listText,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        forecast[index].weather[0].description.toCapitalized(),
                        style: AppTextStyle.listText),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(forecast[index].temp.day.toStringAsFixed(0) + '°C',
                  style: AppTextStyle.listText),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius:const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
