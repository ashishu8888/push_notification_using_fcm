import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:push_notification_using_fcm/error_handling.dart';
import 'package:push_notification_using_fcm/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/utils.dart';
import '../models/user_model.dart';

const uri = 'http://localhost:3000/';

class AuthServices {
  // sign up

  void signUp({
    required context,
    required name,
    required email,
    required password,
    required token,
    required type,
  }) async {
    try {
      User user = User(
        id: 'id',
        name: name,
        email: email,
        password: password,
        type: type,
        token: token,
      );

      final res = await http.post(
        Uri.parse('$uri/api/signup'),
        headers: <String, String>{
          'content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account created! Login with same credential');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signinUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      print(res.body);

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.setString('x-auth-token', jsonDecode(res.body)['token']);

            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(),
              ),
              (route) => false,
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
