import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot<Map<String, dynamic>>> getNews() {
    //FIXME change back to 100
    return _db
        .collection('news')
        .orderBy('publishedAt', descending: true)
        .limit(500)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFav(String uid) {
    return _db.collection('faves').doc(uid).get();
  }

  Future<void> appendFav(
      String uid, List<Map<String, dynamic>> articles) async {
    final currentRef = _db.collection("faves").doc(uid);

    currentRef.update({
      "favlist": FieldValue.arrayUnion(articles),
    });
  }

  Future<void> removeFav(List<Map<String, dynamic>> articles) async {
    final currentRef = _db.collection("faves").doc(_currentUser!.uid);

    currentRef.update({
      "favlist": FieldValue.arrayRemove(articles),
    });
  }
}
