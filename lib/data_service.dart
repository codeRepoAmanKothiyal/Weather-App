import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models.dart';

import 'model_hourly.dart';

class DataService{

  Future<CurrentWeatherInfoModel?> getWeather(String city) async{
    //api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}

    final queryParameters ={
      'q': city,
      'appid':'fa81f33a34ba0891c3b3864560b8fdc5',
      'units': 'metric'
    };

    final uri = Uri.http(
        'api.openweathermap.org','/data/2.5/weather', queryParameters);

    final response = await http.get(uri);
    if(response.statusCode == 200){
      print(response.body);
      final json =jsonDecode(response.body);
      return CurrentWeatherInfoModel.fromJson(json);
    }

    // print(response.body);
   //  final json =jsonDecode(response.body);
    return null;

  }

  Future<FiveDayWeatherForecastModel?> getWeatherForecast(String city) async {
    //api.openweathermap.org/data/2.5/forecast?q={city name}&appid={API key}
    final queryParameters = {
      'q': city,
      'appid': 'fa81f33a34ba0891c3b3864560b8fdc5',
      'units': 'metric'

    };

    final uri = Uri.http('api.openweathermap.org', '/data/2.5/forecast', queryParameters);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return FiveDayWeatherForecastModel.fromJson(json);
    }
    return null;
  }
}
