import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:watchv/utils/downloder.dart';
import 'dart:isolate';
import 'dart:ui';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _videoUrlController = TextEditingController();
  int progress = 0;
  ReceivePort _receivePort = ReceivePort();

  static downloadingInfo(id, status, progress) {
    //Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");
    //Sending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    //register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    //Listening for the data is coming other isolates
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingInfo);
  }

  @override
  void dispose() {
    print('dispose');
    _videoUrlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _videoUrlController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent))),
            ),
          ),
          Text(
            "$progress",
            style: TextStyle(fontSize: 40),
          ),

          SizedBox(
            height: 60,
          ),
          FlatButton(
              child: Text("Download"),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Downloader().startDownloading(_videoUrlController.text,context);
              })
        ],
      ),
    );
  }
}
