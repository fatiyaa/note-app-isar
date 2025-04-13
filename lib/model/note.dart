import 'package:isar/isar.dart';

part 'note.g.dart';

@Collection()
class Note {
  Id id;
  final String title;
  final String note;

  Note({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.note
});
}