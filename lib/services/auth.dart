import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _gsignin = GoogleSignIn();

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserCredential> anonymousLogin() async {
    UserCredential user = await _auth.signInAnonymously();
    updateUserData(user);
    return user;
  }


  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _gsignin.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      updateUserData(user);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<void> updateUserData(UserCredential usercred) async {
  //   DocumentReference userRef = _db.collection('faves').doc(usercred.user?.uid);
  //
  //   return userRef.set({
  //     "uid": usercred.user?.uid,
  //     "lastActivity": DateTime.now(),
  //     "favlist": []
  //   }, SetOptions(merge: true));
  // }
  Future<void> updateUserData(UserCredential usercred) async {
    DocumentReference userRef = _db.collection('faves').doc(usercred.user?.uid);

    // Check if the document exists
    var userDoc = await userRef.get();

    if (userDoc.exists) {
      // If the document exists, update the "favList"
      return userRef.update({
        "lastActivity": DateTime.now(),
      });
    } else {
      // If the document doesn't exist, create a new record with an empty "favList"
      return userRef.set({
        "uid": usercred.user?.uid,
        "lastActivity": DateTime.now(),
        "favlist": [],
      });
    }
  }


  Future<void> signOut() {
    return _auth.signOut();
  }
}
