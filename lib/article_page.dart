import 'package:flutter/material.dart';

import 'package:flutter_testing/article.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          article.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 8,
          bottom: mq.padding.bottom,
          left: 8,
          right: 8,
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(article.content),
          ],
        ),
      ),
    );
  }
}
