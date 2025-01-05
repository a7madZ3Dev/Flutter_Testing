import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_page.dart';
import 'package:flutter_testing/news_service.dart';
import 'package:flutter_testing/news_change_notifier.dart';

class MokeNewsService extends Mock implements NewsService {}

void main() {
  late MokeNewsService mokeNewsService;

  setUp(() {
    mokeNewsService = MokeNewsService();
  });

  final articlesFromService = [
    Article(title: 'Title 1', content: 'Test 1 content'),
    Article(title: 'Title 2', content: 'Test 2 content'),
    Article(title: 'Title 3', content: 'Test 3 content'),
  ];

  void arrangeNewsServiceReturn3Articles() {
    when(() => mokeNewsService.getArticles())
        .thenAnswer((_) async => articlesFromService);
  }

  void arrangeNewsServiceReturn3ArticlesAfter2SecondsWait() {
    when(() => mokeNewsService.getArticles()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return articlesFromService;
    });
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mokeNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    'title is displayed',
    (WidgetTester tester) async {
      /// arrange
      arrangeNewsServiceReturn3Articles();

      /// act
      await tester.pumpWidget(createWidgetUnderTest());

      /// assert
      expect(find.text('Your News'), findsOneWidget);
    },
  );

  testWidgets(
    "loading indicator is displayed while waiting for articles",
    (WidgetTester tester) async {
      /// arrange
      arrangeNewsServiceReturn3ArticlesAfter2SecondsWait();

      /// act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));

      /// assert
      expect(find.byKey(const Key('progress-indicator')), findsOneWidget);

      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "articles are displayed",
    (WidgetTester tester) async {
      /// arrange
      arrangeNewsServiceReturn3Articles();

      /// act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      /// assert
      for (var article in articlesFromService) {
        expect(find.text(article.title), findsOneWidget);
        expect(find.text(article.content), findsOneWidget);
      }
    },
  );
}
