import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pm_data_analysis/models/result_model.dart';
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({super.key});

  @override
  State<FilePickerDemo> createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final TextEditingController myController = TextEditingController();
  final int maxValue = 360;
  int daysToCount = 30;
  void _resetDaysToCount() {
    setState(() {
      myController.clear();
      daysToCount = 30; // Reset to default or any other value you deem fit
      // Optionally, reset the displayed results as well
      final resultModel = Provider.of<ResultModel>(context, listen: false);
      resultModel.setResults(null); // Clear the results
    });
  }

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
      resultModel.setResults(
          'The number of participants in the last 30 days is $numberOfParticipants');
    } else {
      debugPrint('user canceled');
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  int _processCsvContent(String csvContent) {
    // Use the CSV package to parse the CSV content.
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvContent);

    // Assuming the first row is the header and 'date_active' is one of the columns.
    int dateActiveIndex = rowsAsListOfValues[0].indexOf('date_active');
    if (dateActiveIndex == -1) {
      return 0; // 'date_active' column not found.
    }

    // Iterate over the rows, skipping the header.
    int count = 0;
    for (var i = 1; i < rowsAsListOfValues.length; i++) {
      var row = rowsAsListOfValues[i];

      // Parse the 'date_active' field to a DateTime object.
      DateTime? dateActive = DateTime.tryParse(row[dateActiveIndex]);

      // Check if 'date_active' is within the last 30 days.
      if (dateActive != null &&
          dateActive.isAfter(DateTime.now().subtract(
            Duration(days: daysToCount),
          ))) {
        count++;
      }
    }
    return count; // The number of entries within the last 30 days.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VP Data Analyzer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  child: const Text('Pick CSV File'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: myController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                          3), // Limits to 3 characters
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final int? parsedValue = int.tryParse(value);
                        if (parsedValue != null && parsedValue <= maxValue) {
                          daysToCount = parsedValue;
                        } else {
                          myController.text = maxValue.toString();
                          myController.selection = TextSelection.fromPosition(
                              TextPosition(offset: myController.text.length));
                        }
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter number of days (Max: 360)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _resetDaysToCount,
                  tooltip: 'Reset',
                ),
              ],
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
