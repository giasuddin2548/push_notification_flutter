


import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_app/second_screen.dart';
import 'package:path_provider/path_provider.dart';
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

    if(payload!=null){
      await navKey.currentState?.push(MaterialPageRoute(builder: (context) => SecondScreen(payload)));
    }

  }




  static Future<void> showBigTextNotification(FlutterLocalNotificationsPlugin plugin,int id, String title, String body, String payload)async{
    print('Checker:__ ${StackTrace.current} Method Called');

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );


    AndroidNotificationDetails _androidPlatformChannelSpecifics =  AndroidNotificationDetails(
      'channel ID',
      'channel name',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
      ticker: 'ticker',
      styleInformation: bigTextStyleInformation,

    );
    IOSNotificationDetails _iosPlatformChannelSpecifics = const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true
    );





    NotificationDetails platformChannelSpecifics = NotificationDetails(android: _androidPlatformChannelSpecifics, iOS: _iosPlatformChannelSpecifics);
    plugin.show(id, title, body, platformChannelSpecifics, payload: payload,);

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
        presentSound: true,

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



  /// Process-1
  static Future<void> showBigPictureNotificationHiddenLargeIcon(FlutterLocalNotificationsPlugin plugin ,int id, String title, String body, String payload) async {
    // final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(body, 'bigPicture');

    print('uuuu $bigPicturePath');

    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: 'Evaly.com.bd',
      htmlFormatContentTitle: false,
      summaryText: 'New Deal',
      htmlFormatSummaryText: true,
    );


    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      // largeIcon: FilePathAndroidBitmap(largeIconPath),

      priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
    );

    // IOSNotificationDetails _iosPlatformChannelSpecifics =  IOSNotificationDetails(
    //     presentAlert: true,
    //     presentBadge: true,
    //     presentSound: true,
    //     attachments: [IOSNotificationAttachment(bigPicturePath)],
    // );


    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,);
    await plugin.show(id, 'Evaly.com.bd', 'New Deal', platformChannelSpecifics, payload: payload);
  }


  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }










}