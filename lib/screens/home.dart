import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsly/services/auth.dart';
import 'package:newsly/utils/favourites_list.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    if (currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Newsly'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Sign Out',
              onPressed: () async {
                await auth.signOut();
                if (!context.mounted) return;
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
            )
          ],
        ),
        body: Center(
          child: FavList(currentUser),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "news",
          child: const Icon(Icons.rocket_launch),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/swipe', (route) => false);
          },
        ),
      );
    }
    return Center(
        child: TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text("Login")));
  }
}
