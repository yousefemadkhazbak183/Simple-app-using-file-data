import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory tempDir = await getTemporaryDirectory();
  print("tempDir: $tempDir");

  final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  print("appDocumentsDir: $appDocumentsDir");

  final Directory? downloadsDir = await getDownloadsDirectory();
  print("downloadsDir: $downloadsDir");

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

  void _addNote() {
    controller.text.trim();
    setState(() {
      notes.add(controller.text.trim());
      controller.clear();
    });
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
