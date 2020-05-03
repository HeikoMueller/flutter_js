import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class FlutterJs {

  static bool DEBUG = false;
  static const MethodChannel _channel =
      const MethodChannel('io.abner.flutter_js');

  final _didReceiveMessage = new StreamController<WebkitMessage>.broadcast();
  Stream<WebkitMessage> get didReceiveMessage => _didReceiveMessage.stream;
  
  static FlutterJs _instance;
  factory FlutterJs() => _instance ??= new FlutterJs._();
  FlutterJs._() {
    _channel.setMethodCallHandler(_handleMessages);
    _channel.invokeMethod("initEngine", 1);
  }
  Future<Null> _handleMessages(MethodCall call) async {
    switch (call.method) {
      case 'didReceiveMessage':
        _didReceiveMessage.add(WebkitMessage.fromMap(Map<String, dynamic>.from(call.arguments)));
        break;
    }
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> evaluate(String command, int id, {String convertTo = ""}) async {
    id = (id == null) ? 1 : id;
    var arguments = {
      "engineId": id,
      "command": command,
      "convertTo": convertTo
    };
    final rs = await _channel.invokeMethod("evaluate", arguments);
    final String jsResult = rs is Map || rs is List
        ? json.encode(rs)
        : rs;
    if (DEBUG) {
      print("${DateTime.now().toIso8601String()} - JS RESULT : $jsResult");
    }
    return jsResult ?? "null";
  }
}


class WebkitMessage {

  final String name;
  final dynamic data;

  WebkitMessage(this.name, this.data);

  factory WebkitMessage.fromMap(Map<String, dynamic> map) {
    return WebkitMessage(map["name"], map["data"]);
  }
}
