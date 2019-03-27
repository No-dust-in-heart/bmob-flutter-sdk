/**
 * home page
 */
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyUserPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "loginRoute");
                },
                color: Colors.blue[400],
                child: new Text('登录', style: new TextStyle(color: Colors.white))),

            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "registerRoute");
                },
                color: Colors.blue[400],
                child: new Text('注册', style: new TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
