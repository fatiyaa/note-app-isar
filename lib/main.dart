import 'package:flutter/material.dart';
import 'package:ppb_isar/widget/note-add-form.dart';
import 'package:ppb_isar/widget/note-card.dart';

import 'model/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Note> notes = [
    Note(title: 'Title 1', note: 'Note 1'),
    Note(title: 'Title 2', note: 'Note 2'),
  ];

  _addNote(String title, String note) {
    setState(() {
      notes.add(Note(title: title, note: note));
    });
  }

  _editNote(Note oldNote, Note newNote) {
    setState(() {
      notes[notes.indexOf(oldNote)] = newNote;
    });
  }

  _deleteNote(Note note) {
    setState(() {
      notes.remove(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      home: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
          title: const Text(
            'Notes App',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            children:
                notes
                    .map(
                      (note) => NoteCard(
                        title: note.title,
                        note: note.note,
                        deleteNote: () => _deleteNote(note),
                        editNote: (Note newNote) => _editNote(note, newNote),
                      ),
                    )
                    .toList(),
          ),
        ),
        floatingActionButton: NoteAddForm(addNote: _addNote),
      ),
    );
  }
}
