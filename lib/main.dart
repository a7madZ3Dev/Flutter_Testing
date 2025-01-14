import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_testing/news_page.dart';
import 'package:flutter_testing/news_service.dart';
import 'package:flutter_testing/news_change_notifier.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(
          NewsService(),
        ),
        child: const NewsPage(),
      ),
    );
  }
}
