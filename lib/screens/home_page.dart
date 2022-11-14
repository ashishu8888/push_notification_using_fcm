import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:push_notification_using_fcm/constants/utils.dart';
import 'package:push_notification_using_fcm/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  String? mtoken = "";

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAZagzAkY:APA91bEks8v6JWSr6pHgoXpzaTw0UhAlfTx4QwMkX6tf6Sd0Kpis15o9z9oxdu5fdIGTX2S4ue9WWuGHUyRdlEbpXghITV5mmaEAkA4bCRkNJni_kOqLXmbgOIKFzC-JLLv7uYQ1CAte',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click-action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "dbfood",
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              user.name,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'title',
              ),
              controller: title,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'body',
              ),
              controller: body,
            ),
            const SizedBox(
              height: 200,
            ),
            GestureDetector(
              onTap: () async {
                if (user.id.isNotEmpty) {
                  sendPushMessage(user.token, body.text, title.text);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'button',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
