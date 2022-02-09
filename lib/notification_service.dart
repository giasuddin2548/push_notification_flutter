


import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_app/second_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'main.dart';

class NotificationService{
  static Future<void> init(FlutterLocalNotificationsPlugin localNotificationsPlugin)async{

    print('Checker:__ ${StackTrace.current} Method Called');
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    tz.initializeTimeZones();
    await localNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onNotificationClick);
  }
  static Future<void> requestIOSPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    print('Checker:__ ${StackTrace.current} Method Called');
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  static void _onNotificationClick(String? payload) async{
    print('Checker:__ Payload:$payload');
    print('Checker:__ ${StackTrace.current} Method Called');

        (payload)async{
      await navKey.currentState?.push(MaterialPageRoute(builder: (context) => SecondScreen(payload??'No Payload Found')));
    };
  }


  static Future<void> showNotification(FlutterLocalNotificationsPlugin plugin,int id, String title, String body, String payload)async{
    print('Checker:__ ${StackTrace.current} Method Called');

    AndroidNotificationDetails _androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel ID',
      'channel name',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
      ticker: 'ticker',
    );
    IOSNotificationDetails _iosPlatformChannelSpecifics = const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: _androidPlatformChannelSpecifics, iOS: _iosPlatformChannelSpecifics);
    plugin.show(id, title, body, platformChannelSpecifics);

  }

  static void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('Checker:__ ${StackTrace.current} Method Called');
  }

  static void clearNotification(FlutterLocalNotificationsPlugin plugin)async{
    await plugin.cancelAll();
  }

  static void clearOnlyOneNotification(int counter, FlutterLocalNotificationsPlugin plugin)async {
    await plugin.cancel(counter);
  }

  static void showScheduledNotification(FlutterLocalNotificationsPlugin plugin ,int id, String title, String body, String payload)async{

    AndroidNotificationDetails _androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel ID',
      'channel name',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
      ticker: 'ticker',
    );
    IOSNotificationDetails _iosPlatformChannelSpecifics = const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: _androidPlatformChannelSpecifics, iOS: _iosPlatformChannelSpecifics);

    await plugin.zonedSchedule(
      id,
      title,
      body,
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      tz.TZDateTime.parse(tz.local, "2022-02-09 13:46:00"),

      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

  }






}