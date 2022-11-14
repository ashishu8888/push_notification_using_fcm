import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:push_notification_using_fcm/screens/home_page.dart';
import 'package:push_notification_using_fcm/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  AuthServices authServices = AuthServices();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    pass.dispose();
  }

  Future signInUser() async {
    await authServices.signinUser(
      context: context,
      email: email.text,
      password: pass.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                controller: email,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'password',
                ),
                controller: pass,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              GestureDetector(
                onTap: () async {
                  // String name = username.text.trim();
                  // String titleText = title.text.trim();
                  // String bodyText = body.text.trim();
                  signInUser();
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
        ),
      ),
    );
  }
}
