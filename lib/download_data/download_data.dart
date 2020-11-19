import 'package:flutter/material.dart';
import 'package:watchv/utils/data.dart';
import 'package:clipboard/clipboard.dart';

class DownloadData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random url", style: TextStyle(fontSize: 14)),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: urls.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                color: Colors.lightBlue,
                child: ListTile(
                  onTap: () {
                    FlutterClipboard.copy(urls[index])
                        .then((value) => Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Copied"),
                    )));
                  },
                  title: Container(
                      child: Text(
                    urls[index],
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            );
          }),
    );
  }
}
