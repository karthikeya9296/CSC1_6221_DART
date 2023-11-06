import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:newsly/services/news_service.dart';


class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  Stream<QuerySnapshot<Map<String, dynamic>>>? newsStream;

  NewsProvider() {
    newsStream = _newsService.getNews();
  }
}
