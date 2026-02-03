import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();
  List<String> notes = [];

  @override
  void initState() {
    super.initState();

    _loadNotes();
  }

  Future<File> _getFileNotes() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/ notes.json';
    return File(path);
  }

  void _loadNotes() async {
    final File file = await _getFileNotes();
    if (!await file.exists()) {
      notes = [];
    } else {
      final result = await file.readAsString();
      final decoded = jsonDecode(result);
      setState(() {
        notes = List<String>.from(decoded as List);
      });
    }
  }

  void _addNote() {
    final String note = controller.text.trim();
    if (note.isEmpty) return;
    setState(() {
      notes.add(note);
      controller.clear();
    });

    _saveNotes();
  }

  void _saveNotes() async {
    final File file = await _getFileNotes();

    await file.writeAsString(jsonEncode(notes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("JSON File Storage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Add a note",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    _addNote();
                  },
                  child: Text("Add"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text(notes[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
