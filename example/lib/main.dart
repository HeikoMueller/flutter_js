import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_js_example/ajv_example.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterJsHomeScreen(),
    );
  }
}

class FlutterJsHomeScreen extends StatefulWidget {
  @override
  _FlutterJsHomeScreenState createState() => _FlutterJsHomeScreenState();
}

class _FlutterJsHomeScreenState extends State<FlutterJsHomeScreen> {

  String _jsResult = '';
  int _idJsEngine = -1;
  @override
  void initState() {
    super.initState();
    initJsEngine();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initJsEngine() async {


    try {
      _idJsEngine = await FlutterJs.initEngine();
    } on PlatformException catch (e) {
      print('Failed to init js engine: ${e.details}');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterJS Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('JS Evaluate Result: $_jsResult\n'),
            SizedBox(height: 20,),
            Padding(padding: EdgeInsets.all(10), child: Text('Click on the big JS Yellow Button to evaluate the expression bellow using the flutter_js plugin'),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Math.trunc(Math.random() * 100).toString();", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
            ),
            RaisedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AjvExample())), child: const Text('See Ajv Example'),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        child: Image.asset('assets/js.ico'),
        onPressed: () async {
          try {
            String result = await FlutterJs.evaluate(
                "Math.trunc(Math.random() * 100).toString();", _idJsEngine);
            setState(() {
              _jsResult = result;
            });
          } on PlatformException catch (e) {
            print('ERRO: ${e.details}');
          }
        },
      ),
    );
  }
}
