import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_testing/article_page.dart';
import 'package:flutter_testing/news_change_notifier.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        if(mounted){
          return context.read<NewsChangeNotifier>().getArticles();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your News'),
      ),
      body: Consumer<NewsChangeNotifier>(
        builder: (context, notifier, child) {
          if (notifier.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                key: Key('progress-indicator'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            itemCount: notifier.articles.length,
            itemBuilder: (_, index) {
              final article = notifier.articles[index];
              return Card(
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArticlePage(article: article),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(article.title),
                    subtitle: Text(
                      article.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
