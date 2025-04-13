import 'package:flutter/material.dart';
import 'package:ppb_isar/service/db_service.dart';
import 'package:ppb_isar/widget/note-add-form.dart';
import 'package:ppb_isar/widget/note-card.dart';

import 'model/note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
          title: const Text(
            'Notes App',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: Notes(),
        floatingActionButton: NoteAddForm(
          addNote: (String title, String note) {
            DB.instance.addNote(title, note);
          },
        ),
      ),
    );
  }
}

class Notes extends StatelessWidget {
  Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: DB.instance.getNotesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No notes found'));
        } else {
          List<Note> notes = snapshot.data!;

          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children:
                  notes
                      .map(
                        (note) => NoteCard(
                          note: note,
                          deleteNote: () => DB.instance.deleteNote(note.id),
                          editNote:
                              (String title, String desc) =>
                                  DB.instance.updateNote(note.id, title, desc),
                        ),
                      )
                      .toList(),
            ),
          );
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Notes App',
  //     home: Scaffold(
  //       backgroundColor: Colors.deepPurple[50],
  //       appBar: AppBar(
  //         backgroundColor: Colors.deepPurple[200],
  //         title: const Text(
  //           'Notes App',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
  //         ),
  //       ),
  //       body: Expanded(
  //         child: ListView(
  //           padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
  //           children:
  //               notes
  //                   .map(
  //                     (note) => NoteCard(
  //                       title: note.title,
  //                       note: note.note,
  //                       deleteNote: () => _deleteNote(note),
  //                       editNote: (Note newNote) => _editNote(newNote),
  //                     ),
  //                   )
  //                   .toList(),
  //         ),
  //       ),
  //       floatingActionButton: NoteAddForm(addNote: _addNote),
  //     ),
  //   );
  // }
}
