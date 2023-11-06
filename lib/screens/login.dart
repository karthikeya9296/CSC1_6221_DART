import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsly/services/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      debugPrint(user.toString());
      Navigator.pushReplacementNamed(context, '/lists');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                  image: NetworkImage(
                      "https://api.logo.com/api/v2/images?logo=logo_7a49eccb-b148-4ad7-b170-a31024813545&u=2023-10-29T04%3A15%3A37.076Z&margins=0&format=webp&quality=30&width=200&height=200&background=transparent&fit=contain")),
              const Text(
                "Start loving news, one swipe at a time",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.only(top: 100)),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll<Color>(Colors.indigo),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: const BorderSide(color: Colors.grey)))),
                  onPressed: () async {
                    var nav = Navigator.of(context);
                    var userCred = await auth.signInWithGoogle();
                    if (userCred != null) {
                      nav.pushReplacementNamed('/lists');
                    }

                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign in with   ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center),
                      FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      )
                    ],
                  )),
              const Padding(padding: EdgeInsets.only(top: 50)),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll<Color>(Colors.indigo),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: const BorderSide(color: Colors.grey)))),
                onPressed: () async {
                  var nav = Navigator.of(context);
                  await auth.anonymousLogin();
                  nav.pushReplacementNamed('/lists');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Continue as a Guest    ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                    FaIcon(FontAwesomeIcons.glasses, color: Colors.white)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
