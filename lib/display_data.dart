import 'package:flutter/material.dart';
import 'package:watchv/download_data/download_data.dart';
import 'Home/home.dart';

class DisplayData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DisplayDataState();
  }
}

class _DisplayDataState extends State<DisplayData> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyHomePage(),
    DownloadData(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _children.elementAt(_currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.cloud_download),
                label: "Download",
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.copy),
                label: "Copy",
              ),
            ]),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
