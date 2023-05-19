import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/constants/app_constants.dart';
import 'package:my_chat/constants/color_constants.dart';
import 'package:my_chat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      default:
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.loginTitle,
          style: TextStyle(
            color: ColorConstants.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                authProvider.handleSignIn().then((isSuccess) {
                  if (isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
                }).catchError((error, stackTrace) {
                  Fluttertoast.showToast(msg: error.toString());
                  authProvider.handleException();
                });
              },
              icon: const FaIcon(FontAwesomeIcons.google),
              label: const Text("Sign in with Google"),
            ),
          ),
          // Loading
          Positioned(
            child: authProvider.status == Status.authenticating
                ? LoadingView()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
