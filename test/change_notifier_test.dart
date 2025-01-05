import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_service.dart';
import 'package:flutter_testing/news_change_notifier.dart';

class MokeNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MokeNewsService mokeNewsService;

  setUp(() {
    mokeNewsService = MokeNewsService();
    sut = NewsChangeNotifier(mokeNewsService);
  });

  test(
    'initial values are correct',
    () {
      /// assert
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );

  group('getArticles', () {
    final articlesFromService = [
      Article(title: 'Title 1', content: 'Test 1 content'),
      Article(title: 'Title 2', content: 'Test 2 content'),
      Article(title: 'Title 3', content: 'Test 3 content'),
    ];
    void arrangeNewsServiceReturn3Articles() {
      when(() => mokeNewsService.getArticles())
          .thenAnswer((_) async => articlesFromService);
    }

    test(
      'gets articles using the NewsService',
      () async {
        /// arrange
        arrangeNewsServiceReturn3Articles();

        /// act
        await sut.getArticles();

        /// assert
        verify(() => mokeNewsService.getArticles()).called(1);
      },
    );

    test('''indicates loading of data,
    set articles to the ones from the service,
    indicates that data is not being loaded anymore''', () async {
      /// arrange
      arrangeNewsServiceReturn3Articles();

      /// act - assert
      final future = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(sut.articles, articlesFromService);
      expect(sut.isLoading, false);
    });
  });
}
