import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class Downloader extends ChangeNotifier {
  void startDownloading(String url, BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: '/sdcard/Download',
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Permission denied")));
      notifyListeners();
    }
  }
}
