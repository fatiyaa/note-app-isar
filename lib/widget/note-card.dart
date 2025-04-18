import 'package:flutter/material.dart';
import 'package:ppb_isar/model/note.dart';
import 'package:ppb_isar/widget/note-edit-form.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function deleteNote;
  final Function(String, String) editNote;

  const NoteCard({
    super.key,
    required this.note,
    required this.deleteNote,
    required this.editNote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade200.withAlpha(96),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
        color: Colors.deepPurple[50],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(note.note),
              ],
            ),
          ),
          NoteEditForm(editNote: editNote, oldNote: note),
          IconButton(icon: Icon(Icons.delete), onPressed: () => deleteNote()),
        ],
      ),
      //
    );
  }
}
