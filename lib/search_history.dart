import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryItem {
  final String cityName;
  final double temperature;

  SearchHistoryItem(this.cityName, this.temperature);
}

class SearchHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: loadSearchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final searchHistory = snapshot.data;
            return ListView.builder(
              itemCount: searchHistory?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchHistory![index],),
                );
              },
            );
          } else {
            return Text('No search history found.');
          }
        },
      ),
    );
  }

  Future<List<String>> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('search_history') ?? [];
  }
}
