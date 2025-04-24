import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EvaluatePage extends StatefulWidget {
  final String selectedWord;
  final String recordingPath;

  const EvaluatePage({
    super.key,
    required this.selectedWord,
    required this.recordingPath,
  });

  @override
  _EvaluatePageState createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  String resultText = "Evaluating...";

  @override
  void initState() {
    super.initState();
    evaluatePronunciation();
  }

  Future<void> evaluatePronunciation() async {
    final uri = Uri.parse('https://lingomaster-model.onrender.com/upload');
    print("Sending word: ${widget.selectedWord}");
    print("Audio path: ${widget.recordingPath}");

    final request = http.MultipartRequest("POST", uri)
      ..fields['selected_word'] = widget.selectedWord
      ..files.add(
          await http.MultipartFile.fromPath('audio', widget.recordingPath));
    print("Requesting: ${request.url}");

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        double similarity = data['blended_similarity'];
        String label;

        if (similarity <= 20) {
          label = "❌ Bad";
        } else if (similarity <= 40) {
          label = "⚠️ Getting Close";
        } else if (similarity <= 60) {
          label = "👍 Good";
        } else if (similarity <= 80) {
          label = "✅ Very Good";
        } else {
          label = "🌟 Perfect";
        }
        setState(() {
          resultText = "Similarity: ${similarity.toStringAsFixed(2)}% - $label";
        });
      } else {
        setState(() {
          resultText = "Failed to evaluate. Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        resultText = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Evaluation Result"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*  Text("Word: ${widget.selectedWord}"),
          SizedBox(height: 8),
          Text("File: ${widget.recordingPath}"),
          SizedBox(height: 16), */
          Text(
            resultText,
            style: TextStyle(
              fontSize: 18.0, // Set the font size
              fontWeight: FontWeight.bold, // Set the font weight
            ),
          ),
        ],
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary, // Border color
              width: 2.0, // Border width
            ),
            borderRadius:
                BorderRadius.circular(16.0), // Border radius for rounded corners
          ),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ),
      ],
    );
  }
}
