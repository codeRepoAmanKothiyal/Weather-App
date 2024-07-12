import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
        ),
        onChanged: (query) {
        },
      )
          : Text("Weather App"),
      backgroundColor: Colors.deepPurple,
    );
  }
}
