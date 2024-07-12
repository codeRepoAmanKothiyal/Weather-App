import 'package:flutter/material.dart';
import 'package:weather_app/home.dart';
import 'package:weather_app/models.dart';
import 'data_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Weather App",
    home: HomeScreen(),
  ));
}



class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  var _formKey = GlobalKey<FormState>();
  final _minimumPadding = 5.0;
  final _dataService = DataService();

  CurrentWeatherInfoModel _response = CurrentWeatherInfoModel();

  TextEditingController _cityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.deepPurpleAccent,
          child: Padding(
              padding: EdgeInsets.all(_minimumPadding * 2),
              child: Column(
                children: <Widget>[
                  getImageAsset(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _cityTextController,
                      validator: (value) {
                        if (value == "") {
                          return "please enter valid City Name";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'City Name',
                          hintText: "Enter City Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    ),
                  ),
                  Container(
                    width: _minimumPadding * 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {
                       // _search();
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("images/weather.png");
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

/*  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() {
      _response = response!;
      if (_response != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Weather_description(_cityTextController.text);
        }));
      }
    });
    // print(response.weatherInfo.description);
    // print(response.cityName);
    // print(response.temoInfo.temperature);
  }*/
}
