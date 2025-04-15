import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_app/pages/home_record.dart';
import 'package:my_app/main.dart';

class WordsPage extends StatefulWidget {
  @override
  _WordsPageState createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    final String text = await rootBundle.loadString('assets/wordlist.txt');
    setState(() {
      words = text.split('\n').map((word) => word.trim()).where((word) => word.isNotEmpty).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: words.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Word Selected: $word')),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black, width: 2.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        word,
                        style: TextStyle(fontSize: 15, /*fontWeight: FontWeight.bold*/),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
