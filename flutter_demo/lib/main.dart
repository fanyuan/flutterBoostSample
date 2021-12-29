import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_demo/router/RouterKey.dart';
import 'package:flutter_demo/router/RouterPath.dart';

void main() => runApp(FlutterPage());//runApp(MyApp());

class FlutterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FlutterPageState();
  }
}

class _FlutterPageState extends State<FlutterPage>{
  @override
  void initState() {
    super.initState();
    //注册FlutterBoost
    FlutterBoost.singleton.registerPageBuilders({
      //TODO 此处注册Flutter 页面路由 url
      Main.PAGE_MAIN: (pageUrl, params, _) {
        return MainWidget();
      },
      Test.PAGE_HAS_RESULT: (pageUrl, params, _) {
        return HasResultWidget();
      },
      Test.PAGE_HAS_PARAMS: (pageName, params, _) {
        return HasParamsWidget(params);
      },
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FlutterPage",
      builder: FlutterBoost.init(postPush: onRoutePushed),
    );
  }

  void onRoutePushed(String pageName,String uniqueId,Map params,
      Route route,Future future){
    debugPrint("onRoutePushed pageName:$pageName ,uniqueId:$uniqueId");
  }
}
//主页面
class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainWidgetState();
  }
}

class _MainWidgetState extends State<MainWidget> {
  String resultText = "result data :";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FlutterMainActivity'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              //FlutterBoost 关闭当前页面
              FlutterBoost.singleton.closeCurrent();
            },
          ),
        ),
        body: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Text('This is main flutter activity',
                style: TextStyle(fontSize: 28.0, color: Colors.blue)),
            alignment: AlignmentDirectional.center,
          ),
          Container(
              margin: const EdgeInsets.only(top: 10.0),
              alignment: AlignmentDirectional.center,
              child: RaisedButton(
                child: Text('Open flutter page get result'),
                color: Colors.yellow,
                onPressed: () {
                  //启动 Flutter 页面带回调数据
                  FlutterBoost.singleton
                      .open(Test.PAGE_HAS_RESULT)
                      .then((Map<dynamic, dynamic> value) {
                    //回调监听
                    setState(() {
                      resultText = 'Open flutter page result data :\n $value';
                    });
                  });
                },
              )),
          Container(
              margin: const EdgeInsets.only(top: 10.0),
              alignment: AlignmentDirectional.center,
              child: RaisedButton(
                child: Text('Open native page get result'),
                color: Colors.yellow,
                onPressed: () {
                  //启动 Native 页面带回调数据
                  FlutterBoost.singleton
                      .open(Test.PAGE_NATIVE_HAS_RESULT)
                      .then((Map<dynamic, dynamic> value) {
                    //回调监听
                    setState(() {
                      resultText = 'Open flutter page result data :\n $value';
                    });
                  });
                },
              )),
          Container(
              margin: const EdgeInsets.only(top: 10.0),
              alignment: AlignmentDirectional.center,
              child: RaisedButton(
                child: Text('Open native page has request params'),
                color: Colors.yellow,
                onPressed: () {
                  //启动 Native 页面带请求参数和回调数据
                  Map<String, dynamic> requestParams = Map();
                  requestParams[HasRequestParamsNative.EXTRA_KEY_NATIVE] = "Hello native";
                  FlutterBoost.singleton
                      .open(Test.PAGE_NATIVE_HAS_RESULT,
                      urlParams: requestParams)
                      .then((Map<dynamic, dynamic> value) {
                    //回调监听
                    setState(() {
                      resultText = 'Open flutter page result data :\n $value';
                    });
                  });
                },
              )),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            alignment: AlignmentDirectional.center,
            child: Text(resultText),
          ),
        ]));
  }
}

//普通页面（有回调）
class HasResultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HasResultActivity'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              //FlutterBoost 关闭当前页面
              FlutterBoost.singleton.closeCurrent();
            },
          ),
        ),
        body: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Text('This is a flutter activity',
                style: TextStyle(fontSize: 28.0, color: Colors.blue)),
            alignment: AlignmentDirectional.center,
          ),
          Container(
              margin: const EdgeInsets.only(top: 10.0),
              alignment: AlignmentDirectional.center,
              child: RaisedButton(
                child: Text('Close and result data'),
                color: Colors.yellow,
                onPressed: () {
                  // FlutterBoost 关闭当前页面并回调数据给原生页面
                  var resultMap = Map<String, dynamic>();
                  resultMap[HasResult.EXTRA_KEY_NAME] = "张先生";
                  resultMap[HasResult.EXTRA_KEY_AGE] = 26;
                  FlutterBoost.singleton.closeCurrent(result: resultMap);
                },
              )),
        ]));
  }
}

//普通页面（有传参）
class HasParamsWidget extends StatelessWidget {
  final Map params;

  HasParamsWidget(this.params);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HasParamsActivity'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              FlutterBoost.singleton.closeCurrent();
            },
          ),
        ),
        body: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Text('This is a flutter activity',
                style: TextStyle(fontSize: 28.0, color: Colors.blue)),
            alignment: AlignmentDirectional.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Text(
                'Native request params :\n ID = ' +
                    params[HasParams.EXTRA_KEY_ID].toString() +
                    '  GROUP = ' +
                    params[HasParams.EXTRA_KEY_GROUP].toString(),
                style: TextStyle(fontSize: 28.0, color: Colors.blue)),
            alignment: AlignmentDirectional.center,
          )
        ]));
  }
}

/////////////////////////////////////////
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
