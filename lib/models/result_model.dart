import 'package:flutter/material.dart';

class ResultModel with ChangeNotifier {
  String? _fileName;
  String? _results;

  String? get filename => _fileName;
  String? get results => _results;

  void setFilename(String fileName) {
    _fileName = fileName;
    notifyListeners();
  }

  void setResults(String? results) {
    _results = results;
    notifyListeners();
  }
}
