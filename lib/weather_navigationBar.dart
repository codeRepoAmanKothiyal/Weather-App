import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/search_history.dart';

CurvedNavigationBar customNavigationBar(BuildContext context){
  return CurvedNavigationBar(
    backgroundColor: Colors.deepPurpleAccent,
    color: Colors.deepPurple.shade300,
    items: [
      Icon(Icons.home),
      Icon(Icons.history),
    ],
    onTap: (index) {
      if (index == 1) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SearchHistoryPage()),
        );
      } else if (index == 0) {
        Navigator.of(context ).pop(); // Navigate back to the last screen
      }
    },
  );
}