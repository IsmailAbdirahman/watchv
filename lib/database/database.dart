import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../main.dart';

class Database extends ChangeNotifier {
  List<String> ids = [];

  void addData(String id) async {
    Box<String> todayInfo = await Hive.openBox<String>(idsBox);
    todayInfo.add(id);
    notifyListeners();
  }

  getData() async {
    Box<String> todayInfo = await Hive.openBox<String>(idsBox);
    ids = todayInfo.values.toList();
    notifyListeners();
  }
}
