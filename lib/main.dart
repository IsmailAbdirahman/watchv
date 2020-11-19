import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'Home/home.dart';
import 'display_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
      );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DisplayData(),
    );
  }
}
