import 'dart:async';
import 'dart:convert';

import 'banner.dart';
import 'WeatherWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'MyHomePage.dart';

Future<Post> fetchPost() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/posts/5');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int index = 0;

  var homePage;
  var bookPage;
  var musicPage;
  var otherPage;

  _getbody() {
    switch (index) {
      case 0:
        if (homePage == null) {
          homePage = new TabBarView(
            children: [
              new Center(
                  child: new MyHomePage(
                    title: "websocket demo",
                    channel: new IOWebSocketChannel.connect('ws://echo.websocket.org'),
                  )
              ),
              new Center(
                  child:new bannerView()
              ),
              new Center(
                  child: new Text("tab 2")
              ),
              new Center(
                child: WeatherWidget(),
              ),
            ],
          );
        }
        return homePage;
      case 1:
        if (bookPage == null) {
          bookPage = new Center(child: new Text("tab 2"));
        }
//        bookPage = new Center(
//            child: RaisedButton(
//              child: const Text('Show toast'),
//              onPressed: () => Fluttertoast.showToast(
//                  msg: "This is Center Short Toast",
//                  toastLength: Toast.LENGTH_SHORT,
//                  gravity: ToastGravity.BOTTOM,
//                  timeInSecForIos: 1,
//                  backgroundColor: Colors.grey,
//                  textColor: Colors.white
//              ),
//            ),
//          )
//        ;
        return bookPage;
      case 2:
//        musicPage = new Center(
//          child: new Text('音乐'),
//        );
        if (musicPage ==null) {
          musicPage = new Center(
              child: FutureBuilder<Post>(
                  future: fetchPost(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.title);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner
                    return CircularProgressIndicator();
                  }
              )
          );
        }

        return musicPage;
      case 3:
        if (otherPage == null) {
          otherPage = new Center(child: new Text("tab other"));
        }
//        bookPage = new Center(
//            child: RaisedButton(
//              child: const Text('Show toast'),
//              onPressed: () => Fluttertoast.showToast(
//                  msg: "This is Center Short Toast",
//                  toastLength: Toast.LENGTH_SHORT,
//                  gravity: ToastGravity.BOTTOM,
//                  timeInSecForIos: 1,
//                  backgroundColor: Colors.grey,
//                  textColor: Colors.white
//              ),
//            ),
//          )
//        ;
        return otherPage;
    }
  }
  //获取标题的方法
  _getTitle() {
    switch (index) {
      case 0:
        return _forMatchTitle('Tab 1 标题');
      case 1:
        return _forMatchTitle('Tab 2 标题');
      case 2:
        return _forMatchTitle('Tab 3 请求远程内容');
      case 3:
        return _forMatchTitle('Tab 4 标题');
    }
  }

  //formatch标题
  _forMatchTitle(String data) {
    return new Text(data);
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,// 长度为3
      initialIndex: 0,// 默认索引0
      child: new Scaffold(
        appBar: new AppBar(
          title: _getTitle(),
          // 如果是第一个则显示tab，否则不显示
          bottom: index == 0 ? new TabBar(
              tabs: [
                new Tab(icon: new Icon(Icons.video_call)),
                new Tab(icon: new Icon(Icons.book)),
                new Tab(icon: new Icon(Icons.person)),
                new Tab(icon: new Icon(Icons.pan_tool)),
              ]
          ) : null,
        ),

        body: _getbody(),

        drawer: new Drawer(
          elevation: 8.0,
          semanticLabel: '滑动抽屉',
          child: new DrawerLayout(),
        ),
//        bottomNavigationBar: new BottomNavigationBar(
//            onTap: _selectPosition,
//            currentIndex: index,
//            type: BottomNavigationBarType.fixed,
//            iconSize: 18.0,
//            items: new List<BottomNavigationBarItem>.generate(4, (index) {
//              switch (index) {
//                case 0:
//                  return new BottomNavigationBarItem(
//                      icon: new Icon(Icons.movie), title: new Text('tab 1'));
//                case 1:
//                  return new BottomNavigationBarItem(
//                      icon: new Icon(Icons.book), title: new Text('tab 2'));
//                case 2:
//                  return new BottomNavigationBarItem(
//                      icon: new Icon(Icons.music_note), title: new Text('tab 3'));
//                case 3:
//                  return new BottomNavigationBarItem(
//                      icon: new Icon(Icons.music_note), title: new Text('tab 4'));
//              }
//            })),
      ),
    );
  }

  _selectPosition(int index) {
    if (this.index == index) return;
    setState(() {
      this.index = index;
    });
  }

}
// 抽屉
class DrawerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new DrawerHeader(
          decoration: new BoxDecoration(
            color: Colors.grey[400],
          ),
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: new Column(
                    children: <Widget>[
                      new CircleAvatar(
                        child: new Text('R'),
                      ),
                      new Text('Ky——R', style: Theme
                          .of(context)
                          .textTheme
                          .title),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        new AboutListTile(
          icon: new Icon(Icons.person),
          child: new Text('关于项目'),
          applicationLegalese: '',
          applicationName: 'Flutter Demo',
          applicationVersion: 'version:1.0',
        ),
      ],
    );
  }
}

// Banner 壁纸
class bannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BannerView(
      data: ['images/demo01.jpg', 'images/demo02.jpg', 'images/demo03.jpg'],
      buildShowView: (index, data) {
        print(data);
        return new Center(
            child: new Container(
              child: new Image.asset(
                data,
                fit: BoxFit.fill,
              ),
            )
        );
      },
      scrollTime: 2000,
      //点击事件
      onBannerClickListener: (index, data) {
        _showToast(context, data);
      },
    );
  }

  void _showToast(BuildContext context, String message) {
    SnackBar snack = new SnackBar(content: new Text(message),backgroundColor: Colors.blue,);
    Scaffold.of(context).showSnackBar(snack);
  }
}