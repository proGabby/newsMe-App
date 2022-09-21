class Article {
  final String title;
  final String content;

  Article({
    required this.title,
    required this.content,
  });

  Article copyWith({
    String? title,
    String? content,
  }) {
    return Article(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  String toString() => 'Article(title: $title, content: $content)';

  //overriding equality operator to ensure Article can be compare by value and not be reference
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Article && other.title == title && other.content == content;
  }

  @override
  int get hashCode => title.hashCode ^ content.hashCode;
}
