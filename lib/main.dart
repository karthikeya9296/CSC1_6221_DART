import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newsly/screens/home.dart';
import 'package:newsly/screens/login.dart';
import 'package:newsly/screens/swipe.dart';
import 'package:provider/provider.dart';
import 'package:newsly/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider.value(value: AuthService().user, initialData: null)
        ],
        child: MaterialApp(
            title: 'App Title',
            routes: {
              '/': (context) => const LoginScreen(),
              '/lists': (context) => Home(),
              '/swipe': (context) => const Newsly(),
            },
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: Colors.indigo,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              primaryColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false));
  }
}
