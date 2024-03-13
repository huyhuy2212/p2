import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsListPage(),
    );
  }
}

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {

    String apiUrl =
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f8bb7a44a3a54ddc8a3025e0e72c6b67';


    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        articles = (jsonData['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News List'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(articles[index].title),
            subtitle: Text(articles[index].source),
            onTap: () {

            },
          );
        },
      ),
    );
  }
}

class Article {
  final String source;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;

  Article({
    required this.source,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: json['source']['name'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'],
    );
  }
}
