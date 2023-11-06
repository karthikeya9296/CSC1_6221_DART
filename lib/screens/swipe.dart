import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:newsly/models/article_model.dart';
import 'package:newsly/screens/home.dart';
import 'package:newsly/services/news_service.dart';
import 'package:newsly/utils/article_card.dart';

class Newsly extends StatefulWidget {
  const Newsly({
    Key? key,
  }) : super(key: key);

  @override
  State<Newsly> createState() => _NewslyPageState();
}

List<ArticleCard> cards = [];

class _NewslyPageState extends State<Newsly> {
  final CardSwiperController controller = CardSwiperController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> newsArticleStream;
  late AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> sn;
  List<Map<String, dynamic>> likedArticles = [];
  NewsService newsService = NewsService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    newsArticleStream = newsService.getNews();
    super.initState();
  }

  @override
  void dispose() {
    cards = [];
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: newsArticleStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            sn = snapshot;
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Flexible(
                      child: CardSwiper(
                          controller: controller,
                          cardsCount: snapshot.data!.docs.length,
                          onSwipe: _onSwipe,
                          numberOfCardsDisplayed: 3,
                          backCardOffset: const Offset(40, 40),
                          padding: const EdgeInsets.all(24.0),
                          cardBuilder: (
                            context,
                            index,
                            horizontalThresholdPercentage,
                            verticalThresholdPercentage,
                          ) =>
                              ArticleCard(Article.fromMap(
                                  snapshot.data!.docs[index].data()))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            heroTag: "unlike",
                            onPressed: controller.swipeLeft,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.close),
                          ),
                          FloatingActionButton(
                            heroTag: "home",
                            onPressed: () => {
                              newsService
                                  .appendFav(currentUser!.uid, likedArticles)
                                  .then((value) => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()),
                                        )
                                      })
                            },
                            child: const Icon(Icons.home),
                          ),
                          FloatingActionButton(
                            heroTag: "like",
                            onPressed: controller.swipeRight,
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.done),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (currentIndex != null &&
        currentIndex < sn.data!.docs.length &&
        direction.name.toString() == "right") {
      Map<String, dynamic> article = sn.data!.docs[currentIndex].data();
      likedArticles.add(article);
    }
    return true;
  }
}
