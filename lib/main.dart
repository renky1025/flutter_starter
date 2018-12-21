
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'HomePage.dart';
import 'MyHomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'home',
//      home: new MyHomePage(
//        title: "websocket demo",
//        channel: new IOWebSocketChannel.connect('ws://echo.websocket.org'),
//      ),
      home: new HomePage(),
    );
  }
}
