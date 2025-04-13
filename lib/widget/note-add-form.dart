import 'package:flutter/material.dart';

class NoteAddForm extends StatefulWidget {
  final Function (String, String) addNote;
  NoteAddForm({super.key, required this.addNote});

  @override
  NoteAddFormState createState() => NoteAddFormState();
}

class NoteAddFormState extends State<NoteAddForm> {
  String title = '';
  String note = '';

  _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Your Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => setState(() => title = value),
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) => setState(() => note = value),
                decoration: InputDecoration(labelText: 'Your Note'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.addNote(title, note);
                        Navigator.pop(context);
                      },
                      child: Text('Add Note'),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple[200],
      onPressed: _showAddNoteDialog,
      child: Icon(Icons.add),
    );
  }
}
