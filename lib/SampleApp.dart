import 'package:flutter/material.dart';
import 'package:flutter_app/FadeAppTest.dart';
import 'package:flutter_app/LifecycleWatcher.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
      routes: <String,WidgetBuilder>{
        '/a': (BuildContext context) => new FadeAppTest(),
        '/b': (BuildContext context) => new LifecycleWatcher(),
      },
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  // Default placeholder text
  String textToShow = "I Like Flutter";

  bool toggle = true;

  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new Center(
          child:
            _getToggleChild(),
//          new MaterialButton(
//            onPressed: (){},
//            child: new Text(textToShow),
//            padding: new EdgeInsets.only(left: 100.0),
//          )
      ),
      floatingActionButton: new FloatingActionButton(
//        onPressed: _updateText,
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }

  _getToggleChild() {
    if (toggle) {
      return  new MaterialButton(
        onPressed: _animation,
        child: new Text('Flutter动画'),
        padding: new EdgeInsets.only(left: 100.0),
      );
    } else {
      return  new MaterialButton(
        onPressed: _lifeCycle,
        child: new Text('Flutter生命周期'),
        padding: new EdgeInsets.only(right: 100.0),
      );
    }
  }

  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

//  动画
  void _animation() {
    Navigator.of(context).pushNamed('/a');
  }

//生命周期
  void _lifeCycle() {
    Navigator.of(context).pushNamed('/b');
  }
}