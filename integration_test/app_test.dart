import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_page.dart';
import 'package:flutter_testing/article_page.dart';
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
    """Tapping on the first article excerpt opens the article page
     where the full article content is displayed""",
    (WidgetTester tester) async {
      /// arrange
      arrangeNewsServiceReturn3Articles();

      /// act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.tap(find.text('Test 1 content'));
      await tester.pumpAndSettle();

      /// assert
      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);
      expect(find.text('Title 1'), findsOneWidget);
      expect(find.text('Test 1 content'), findsOneWidget);
    },
  );
}
