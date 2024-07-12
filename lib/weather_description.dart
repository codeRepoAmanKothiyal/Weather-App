import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_service.dart';
import 'model_hourly.dart';
import 'models.dart';

class Weather_description extends StatefulWidget {
  final String text;

  const Weather_description(this.text, {super.key});

  @override
  State<Weather_description> createState() => _Weather_descriptionState();
}

class _Weather_descriptionState extends State<Weather_description> {
  DataService _dataService = DataService();
  final _minimumPadding = 5.0;

  CurrentWeatherInfoModel _response = CurrentWeatherInfoModel();

  late Future<CurrentWeatherInfoModel?> _responseFuture;
  late Future<FiveDayWeatherForecastModel?> _forecastResponseFuture;

  @override
  void initState() {
    super.initState();
    //  _initializeData();
  }

  Future<void> _initializeData(String city) async {
    _responseFuture = apiCalling(city);
    _forecastResponseFuture = apiCallingForecast(city);

    await Future.wait([
      _responseFuture,
      _forecastResponseFuture,
    ]);

    setState(() {
      // State update here
    });
  }

  Future<void> saveSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> searchHistory = prefs.getStringList('search_history') ?? [];
    searchHistory.insert(0, query);
    if (searchHistory.length > 10) {
      searchHistory
          .removeLast(); // Limit the history to a certain number of items (e.g., 10)
    }
    await prefs.setStringList('search_history', searchHistory);
  }

  Future<CurrentWeatherInfoModel?> apiCalling(String city) async {
    final response = await _dataService.getWeather(city);

    // Check if the response is valid
    if (response == null || response.name == null) {
      // Handle invalid response
      return null;
    }

    // Save the search query to history
    saveSearchHistory(city);
    return response;
  }


  Future<FiveDayWeatherForecastModel?> apiCallingForecast(String city) async {
    return await _dataService.getWeatherForecast(city);
  }

  TextEditingController _cityTextController = TextEditingController();
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white30,
          child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          
                          keyboardType: TextInputType.text,
                          controller: _cityTextController,
                          validator: (value) {
                            if (_response ! == "") {
                              return "please enter City Name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'City Name',
                              hintText: "Enter City Name",
                              contentPadding: EdgeInsets.only(top: 0.0 , bottom: 0.0, left: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {
                        if(_cityTextController.text == "" ||
                            _cityTextController.text.endsWith(" ")){
                          print("Enter City First");
                        }else{
                          _initializeData(_cityTextController.text);
                          setState(() {
                            showDescription = true;
                          });
                        }

                        //  _search();
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                showDescription
                    ?
                FutureBuilder<CurrentWeatherInfoModel?>(
                  future: _responseFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error1: ${snapshot.error}");
                    } else if (snapshot.connectionState ==
                        ConnectionState.done ) {
                      final _response = snapshot.data;
                      print("Error: ${snapshot.data}");
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            EdgeInsets.all(_minimumPadding * 2),
                            child: Card(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15.0),
                              ),
                              color: Colors.deepPurple.shade300,
                              // padding: EdgeInsets.all(_minimumPadding*4),
                              child: Padding(
                                padding:
                                EdgeInsets.all(_minimumPadding * 2),
                                child: Column(
                                  children: [
                                    Image.network(
                                        "http://openweathermap.org/img/wn/${_response?.weather?.first.icon}@2x.png"),
                                    Text(
                                      '${_response?.main?.temp}°C',
                                      style: TextStyle(
                                        fontSize: 60.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(Icons.pin_drop),
                                    Text(
                                      '${_response?.name}',
                                      style: TextStyle(fontSize: 40.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "${_response?.weather?.first.description}",
                                      style: TextStyle(fontSize: 37.0),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(_minimumPadding),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade100,
                                  borderRadius:
                                  BorderRadius.circular(20.0)),
                              child: Padding(
                                padding:
                                EdgeInsets.all(_minimumPadding * 3),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Text(
                                          "${_response?.wind?.speed}",
                                          style:
                                          TextStyle(fontSize: 20.0),
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(
                                          Icons.wind_power,
                                        ),
                                        Text(
                                          "Wind",
                                          style:
                                          TextStyle(fontSize: 20.0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 3,
                                      color: Colors.black,
                                      height: 30,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            "${_response?.main?.pressure}",
                                            style: TextStyle(
                                                fontSize: 20.0),
                                            textAlign:
                                            TextAlign.center),
                                        Icon(Icons.air),
                                        Text("Pressure",
                                            style: TextStyle(
                                                fontSize: 20.0),
                                            textAlign:
                                            TextAlign.center),
                                      ],
                                    ),
                                    Container(
                                      width: 3,
                                      color: Colors.black,
                                      height: 30,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            "${_response?.main?.humidity}",
                                            style: TextStyle(
                                                fontSize: 20.0),
                                            textAlign:
                                            TextAlign.center),
                                        Icon(Icons.water_drop),
                                        Text(
                                          " Humidity",
                                          style:
                                          TextStyle(fontSize: 20.0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text("Data is in an undefined state");
                    }
                  },
                ) : SizedBox(),
                 Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          showDescription
                              ? FutureBuilder<FiveDayWeatherForecastModel?>(
                              future: _forecastResponseFuture,
                              builder: (context, forecastSnapshot) {
                                if (forecastSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (forecastSnapshot.hasError) {
                                  return Text(
                                      "Forecast Error: ${forecastSnapshot.error}");
                                } else if (forecastSnapshot.connectionState ==
                                    ConnectionState.done) {
                                  final _forecastResponse = forecastSnapshot.data;
                                  return Column(
                                    children: <Widget>[
                                      Text(
                                        "Five-Day Forecast:",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                         shrinkWrap: true,
                                          itemCount:
                                              _forecastResponse?.list?.length,
                                          itemBuilder: (context, index) {
                                            return _forecastResponse
                                                        ?.list![index].dtTxt!
                                                        .split(" ")
                                                        .last ==
                                                    "09:00:00"
                                                ? Card(
                                                    elevation: 20,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(15.0),
                                                    ),
                                                    color: Colors.white60,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          _minimumPadding *
                                                              2),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Row(
                                                            children: [
                                                              Image.network(
                                                                  "http://openweathermap.org/img/wn/${_forecastResponse?.list?[index].weather?.first.icon}@2x.png"),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    "${_forecastResponse?.list?[index].dtTxt?.split(" ").first}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            23.0),
                                                                  ),
                                                                  Text(
                                                                    "${_forecastResponse?.list![index].main?.temp} °C",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            30.0),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ))
                                                : SizedBox();
                                          }),
                                    ],
                                  );
                                } else {
                                  return Text(
                                      "Forecast Data is in an undefined state");
                                }
                              })  : SizedBox()
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    if (response != null) {
      setState(() {
        _response = response;
        showDescription = true;
      });
    }
  }
}
