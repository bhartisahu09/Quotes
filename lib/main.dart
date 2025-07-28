import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/provider/quotes_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuoteProvider()..loadQuotes()),
      ],
      child: const QuotesApp(),
    ),
  );
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF9C27B0),
        fontFamily: 'Georgia',
      ),
      home: const HomeScreen(),
    );
  }
}