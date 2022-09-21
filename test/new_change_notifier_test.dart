import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/article.dart';
import 'package:news_app/news_change_notifier.dart';
import 'package:news_app/news_service.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sysUnderSystem;
  late MockNewsService mockNewsService;

  setUp(() {
    //initializing the values
    mockNewsService = MockNewsService();
    sysUnderSystem = NewsChangeNotifier(mockNewsService);
  });

  //testing to check the init value inside the new_change_notifier file is always correct
  test(
    "checking that initial values are correct",
    () {
      expect(sysUnderSystem.articles, []);
      expect(sysUnderSystem.isLoading, false);
    },
  );

  group(
    "getArticles",
    () {
      final testedAricles = [
        Article(title: "test1", content: "test artcle 1"),
        Article(title: "test2", content: "test artcle 2"),
      ];

      void arrangeNewsServiceAndReturnArticles() {
        when(() => mockNewsService.getArticles())
            .thenAnswer((_) async => testedAricles);
      }

      test(
        "gets articles using the NewsService",
        () async {
          //c.
          arrangeNewsServiceAndReturnArticles();
          //a
          await sysUnderSystem.getArticles();
          //b. verifying the getArticles method is called atleast once
          verify(() => mockNewsService.getArticles()).called(1);
        },
      );

      test("""indicates loading of data,
      sets articles to the ones from the service,
      indicates that data is not being loaded anymore""", () async {
        arrangeNewsServiceAndReturnArticles();
        final future = sysUnderSystem.getArticles();
        expect(sysUnderSystem.isLoading, true);
        await future;
        expect(sysUnderSystem.articles, testedAricles);
        expect(sysUnderSystem.isLoading, false);
      });
    },
  );
}
