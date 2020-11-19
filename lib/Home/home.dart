import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
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
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

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
    // initializePlayer();
  }

  @override
  void dispose() {
    print('dispose');
    _videoUrlController.dispose();
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer(String url) async {
    String unWantedString = url.substring(0, 65);
    String wantedString = url.replaceAll(unWantedString, "");
    final status = await Permission.storage.request();
    if (status.isGranted) {
      var myFile = new File("/sdcard/Download/$wantedString");

      _videoPlayerController1 = VideoPlayerController.file(myFile);
      await _videoPlayerController1.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: true,
        looping: true,
      );

      setState(() {});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Downloader",
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
                startDownloading(_videoUrlController.text, context);
              }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10.0),
              child: Center(
                child: _chewieController != null &&
                        _chewieController.videoPlayerController.value.initialized
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startDownloading(String url, BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: '/sdcard/Download',
        showNotification: true,
        openFileFromNotification: true,
      ).then((_) => initializePlayer(url));
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Permission denied")));
    }
  }
}
