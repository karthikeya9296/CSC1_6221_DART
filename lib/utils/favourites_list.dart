import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsly/models/article_model.dart';
import 'package:newsly/services/news_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'date_formatter.dart';

class FavList extends StatefulWidget {
  final User? user;
  final NewsService ns = NewsService();

  FavList(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  State<FavList> createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> likedArticles;

  @override
  void initState() {
    super.initState();
    likedArticles = widget.ns.getFav(widget.user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>?>>(
      future: likedArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('No favorite articles yet.'));
        } else {
          Map<String, dynamic>? data = snapshot.data!.data();
          if (data == null || data['favlist'] == null) {
            return const Center(child: Text('No favorite articles yet.'));
          }

          List<Map<String, dynamic>> favList =
              List<Map<String, dynamic>>.from(data['favlist']);

          return SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true, // To make it fit the content's height.
              physics: const BouncingScrollPhysics(),
              itemCount: favList.length,
              itemBuilder: (context, index) {
                Article article = Article.fromMap(favList[index]);
                return Dismissible(
                    key: Key(article.title),
                    onDismissed: (dir) => {
                      widget.ns.removeFav([favList[index]])
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          article.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Text(
                                'Author:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  article.author,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(color: Colors.grey),
                                ), // Adjust the flex value as needed.
                              ),
                            ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormatter.formatTimeAgo(
                                        article.publishedAt),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  OutlinedButton(
                                      onPressed: () async {
                                        await launchUrl(Uri.parse(article.url));
                                      },
                                      child: const Text("OPEN"))
                                ]),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          );
        }
      },
    );
  }
}
