import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ppb_isar/model/note.dart';

class DB {
  static final DB _instance = DB();
  static DB get instance => _instance;

  late Future<Isar> db;

  DB() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [NoteSchema], // Add your schemas here
      directory: dir.path,
      inspector: true,
    );
  }

  Stream<List<Note>> getNotesStream() async* {
    final isar = await db;
    yield* isar.notes.where().watch(fireImmediately: true);
  }

  Future<void> addNote(String title, String desc) async {
    final isar = await db;
    Note note = Note(title: title, note: desc);
    await isar.writeTxn(() => isar.notes.put(note));
  }

  Future<List<Note>> getNotes() async {
    final isar = await db;
    try {
      return await isar.notes.where().findAll();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteNote(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.notes.delete(id));
  }

  Future<void> updateNote(int id, String title, String desc) async {
    final isar = await db;
    Note note = Note(id: id, title: title, note: desc);
    await isar.writeTxn(() => isar.notes.put(note));
  }
}
