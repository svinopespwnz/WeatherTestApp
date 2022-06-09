import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_test_app/bloc/bloc.dart';
import 'package:weather_test_app/weather_repository/weather_repository.dart';
import 'package:weather_test_app/widgets/second_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(// внедряем Cubit
      create: (context) => ForecastCubit(context.read<WeatherRepository>()),
      child: FirstScreenView(),
    );
  }
}

class FirstScreenView extends StatefulWidget {
  FirstScreenView({Key? key}) : super(key: key);
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreenView> {
  TextEditingController _textController = TextEditingController();// текст контроллер для ввода
  String get _text=>_textController.text;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();//настройка для вывода символов даты
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForecastCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Введите название города'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _textController,
                      decoration:const InputDecoration(
                        hintText: 'Поиск',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.purple, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.purple, width: 1.0),
                        ), )),
                ),
                ElevatedButton(
                  onPressed: () async{
                  await cubit.fetchForecast(_text);//по нажатию на кнопку происходит получение данных
                   Navigator.of(context).push<void>(
                       SecondScreen.route(context.read<ForecastCubit>()));// навигация ко второму экрану

                  },
                  child:const Text('Подтвердить'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
