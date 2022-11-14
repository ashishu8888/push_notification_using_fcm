// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:push_notification_using_fcm/error_handling.dart';
import 'package:push_notification_using_fcm/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/utils.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

const uri = 'http://10.20.15.96:3000';

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
        body: user.toJson(),
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

  Future signinUser({
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
            print(res.body);
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await pref.setString('x-auth-token', jsonDecode(res.body)['token']);

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

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      print('hello');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      print("token is $token");
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);
      print(response.toString());

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
        print(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
