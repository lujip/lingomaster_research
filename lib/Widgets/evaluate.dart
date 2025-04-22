import 'package:flutter/material.dart';

class EvaluatePage extends StatelessWidget {
  final String selectedWord;
  final String recordingPath;

  const EvaluatePage({
    super.key,
    required this.selectedWord,
    required this.recordingPath,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Evaluation Result"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Word: $selectedWord"),
          SizedBox(height: 8),
          Text("File: $recordingPath"),
          SizedBox(height: 16),
          Text("Your pronunciation is good!"), // Placeholder
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Close"),
        ),
      ],
    );
  }
}
