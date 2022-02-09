import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_app/notification_service.dart';

FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();
final navKey =  GlobalKey<NavigatorState>();

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(flnp);
  if(Platform.isIOS){
    print('Checker:__ ${StackTrace.current} Method Called');
    await NotificationService.requestIOSPermissions(flnp);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      title: 'Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Notification App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {
    print('Checker:__ $runtimeType ${StackTrace.current} Method Called');
    setState(() {

      NotificationService.showScheduledNotification(plugin, _counter++, 'A Notification From My App', 'This notification is brought to you by Local Notifcations Package', 'data');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),

            RaisedButton(onPressed: (){
              setState(() {
                _counter=0;
                NotificationService.clearNotification(plugin);
              });
            }, child: const Text('Clear All Notification'),),
            RaisedButton(onPressed: (){
     setState(() {
       _counter--;
       NotificationService.clearOnlyOneNotification(_counter, plugin);
     });

            }, child: const Text('Clear One Notification'),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
