import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pm_data_analysis/models/result_model.dart';
import 'package:provider/provider.dart';

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({super.key});

  @override
  State<FilePickerDemo> createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  Future<void> _pickFile() async {
    final resultModel = Provider.of<ResultModel>(context, listen: false);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      final fileBytes = file.bytes;
      final csvContent = utf8.decode(fileBytes!);
      //use provider to set file and results
      resultModel.setFilename(file.name);
      final numberOfParticipants = _processCsvContent(csvContent);
      resultModel.setResults(file.name);

      // TODO: Implement the CSV file reading and processing logic
    } else {
      // User canceled the picker
    }
  }

  int _processCsvContent(String csvContent) {
    return 50;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV File Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick CSV File'),
            ),
            const SizedBox(height: 20),
            Consumer<ResultModel>(
              builder: (context, resultModel, child) => Text(
                resultModel.filename ?? 'No file selected',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<ResultModel>(
              builder: (context, resultModel, child) => Text(
                resultModel.results ?? 'Results will be displayed here',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
