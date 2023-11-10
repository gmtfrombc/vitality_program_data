import 'package:flutter/material.dart';

class ResultModel with ChangeNotifier {
  String? _fileName;
  String? _results;

  String? get results => _results;
  String? get filename => _fileName;

  void setFilename(String fileName) {
    _fileName = filename;
    notifyListeners();
  }

  void setResults(String fileName) {
    _results = results;
    notifyListeners();
  }
}
