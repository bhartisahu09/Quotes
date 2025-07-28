import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class QuoteProvider with ChangeNotifier {
  // quotes list data in _quotes
  List<Map<String, String>> _quotes = [];
  bool _loading = true;
  String? _error;
  int _currentIndex = 0;

  List<Map<String, String>> get quotes => _quotes;
  bool get loading => _loading;
  String? get error => _error;
  int get currentIndex => _currentIndex;

  // get data from json file and store it in _quotes list
  Future<void> loadQuotes() async {
    try {
      final String data = await rootBundle.loadString('assets/quotes.json');
      final List<dynamic> jsonResult = json.decode(data);
      _quotes = jsonResult
          .map((e) => {
                'text': e['text'] as String,
                'author': e['author'] as String,
                'image': e['image'] as String,
              })
          .toList();
      _loading = false;
    } catch (e) {
      _error = 'Failed to load quotes.';
      _loading = false;
    }
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Map<String, String> get currentQuote =>
      _quotes.isNotEmpty ? _quotes[_currentIndex] : {};
}
