import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/article.dart';
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

  void arrangeNewsServiceAndReturnArticlesAfter3Seconds() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 3));
      return testedAricles;
    });
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

  //testing static widget
  testWidgets("title is displayed", (WidgetTester tester) async {
    arrangeNewsServiceAndReturnArticles(); //c
    await tester.pumpWidget(createWidgetUnderTest()); //b
    expect(find.text("News"), findsOneWidget); //a
  });

  //testing dynamic generated widget
  testWidgets(
    "loadding indicator is displayed while waiting for articles",
    (WidgetTester tester) async {
      arrangeNewsServiceAndReturnArticlesAfter3Seconds();

      await tester.pumpWidget(createWidgetUnderTest());
      //pump forces rebuild of the testwidget
      await tester.pump(const Duration(milliseconds: 500));

      //expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key("c-progressor1")), findsOneWidget);
      await tester.pumpAndSettle();
    },
  );

  testWidgets("articles are displayed", (WidgetTester tester) async {
    arrangeNewsServiceAndReturnArticles();
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump();
    for (final article in testedAricles) {
      expect(find.text(article.content), findsOneWidget);
      expect(find.text(article.title), findsOneWidget);
    }
  });
}
