import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/article.dart';
import 'package:news_app/article_page.dart';
import 'package:news_app/new_page.dart';
import 'package:news_app/news_change_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/news_service.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final testedAricles = [
    Article(title: "test1", content: "test artcle 1"),
    Article(title: "test2", content: "test artcle 2"),
  ];

  void arrangeNewsServiceAndReturnArticles() {
    when(() => mockNewsService.getArticles())
        .thenAnswer((_) async => testedAricles);
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    """Tapping on the first article excerpt opens the article page 
    where the full article content is displayed""",
    (WidgetTester tester) async {
      arrangeNewsServiceAndReturnArticles();

      //
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      //enabling the tapping tester
      await tester.tap(find.text('test article 1'));
      //to wait for all animation to settle
      await tester.pumpAndSettle();
      //check we're no longer on the news page
      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);
      //check for the title and context of the 1st article is found
      expect(find.text('test1'), findsOneWidget);
      expect(find.text('test artcle 1'), findsOneWidget);
    },
  );
}
