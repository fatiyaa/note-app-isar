# Tugas 2 PPB C Implementasi Isar Database

| Name          | NRP        | Kelas                            |
| ------------- | ---------- | -------------------------------- |
| Fatiya Izzati | 5025221187 | Pemrograman Perangkat Bergerak C |

Berikut ini merupakan langkah-langkah implementasi database Isar, dimulai dari instalasi, setup database, hingga mengaplikasikannya ke project flutter sehingga CRUD dapat berjalan dengan baik. Dalam project ini saya melanjutkan project simple CRUD sebelumnya sehingga nantinya cukup mengubah pendekatannya dari List ke Database.

## Clone Flutter Project

Link Github : https://github.com/fatiyaa/ppb-note-app.git

Di project tersebut, telah terdapat fungsi CRUD dengan memanfaatkan list untuk membuat notes. Terdapat file utama yaitu `main.dart` dan dua folder untuk model dan widget. `main.dart` akan memuat dan menampilkan halaman utama serta menyimpan fungsional notes. Folder model terdiri dari file `note.dart` yang berisi penyusun objek note atau class `Note`. Folder widget berisi elemen elemen yang akan di view pada halaman berdasarkan aksi. `note_card.dart` digunakan untuk view tiap list note, `note_add_form` dan `note_edit_form.dart` akan menampilkan popup form saat memilih aksi add dan edit. `home_page.dart`, dan `todo_list.dart`.

## Instalasi Isar DB

Instalasi dan tutorial lebih lengkap dapat dilihat melalui website resmi Isar: https://isar.dev/tutorials/quickstart.html

Untuk memulai menggunakan Isar, perlu menambahkan beberapa package ke `pubspect.yaml`. Dapat dilakukan dengan flutter pub sebagai berikut:

```sh
    flutter pub add isar isar_flutter_libs path_provider
    flutter pub add -d isar_generator build_runner
```

## Create Database Model

Isar merupakan noSQL database sehingga datanya akan disimpan dalam bentuk collection. Pada tugas sebelumnya, telah dibuat kelas model pada file `note.dart` sehingga dibutuhkan beberapa penyesuaian agar kelas tersebut dapat menjadi collection.

`note.dart` before using isar

```dart
    class Note {
        final String title;
        final String note;

        Note({
            required this.title,
            required this.note
        });
    }
```

`note.dart` after using isar

```dart
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
```

`part 'note.g.dart';` digunakan untuk menyambungkan file model Dart dengan file yang dihasilkan otomatis oleh generator kode Isar. Untuk melakukan build model atau schema tersebut jalankan flutter pub di terminal.

```sh
flutter pub run build_runner build
```

Maka database sudah siap digunakan.

## Create Database Service

Setelah database dibuat, giliran service untuk database dibuat. Hal ini bertujuan sebagai sarana interaksi aplikasi dengan database. Service ini terkait dengan proses masuk atau keuarnya data dari database, meliputi open connection database dan transaksi CRUD.

### Open Connection Service

Dalam berinteraksi dengan database diperlukan connection sehingga dibuat kode untuk mencapai hal tersebut.

```dart
    Future<Isar> openIsar() async {
        final dir = await getApplicationDocumentsDirectory();
        return await Isar.open(
        [NoteSchema], // Add your schemas here
        directory: dir.path,
        inspector: true,
        );
    }
```

Fungsi ini mengembalikan objek Isar yang terhubung ke database untuk digunakan dalam operasi penyimpanan dan pengambilan data.

### CRUD Service

Dalam setiap transaksi pasti dilakukan await agar proses asinkronus akan dimulai setelah database siap digunakan.

- Create Service
  ```dart
  Future<void> addNote(String title, String desc) async {
      final isar = await db;
      Note note = Note(title: title, note: desc);
      await isar.writeTxn(() => isar.notes.put(note));
  }
  ```
  `writeTxn` memastikan bahwa perubahan yang dilakukan pada database dilakukan dalam satu transaksi. Jika terjadi kesalahan di tengah-tengah proses, perubahan yang dilakukan dapat dibatalkan (rollback), menjaga integritas data.
- Read Service
  ```dart
  Stream<List<Note>> getNotesStream() async* {
      final isar = await db;
      yield* isar.notes.where().watch(fireImmediately: true);
  }
  ```
  Dalam service get digunakan stream agar data dari db yang akan di view akan selalu update dan diperbarui dengan cepat. `async*` digunakan untuk mendeklarasikan fungsi generator asinkron yang mengembalikan stream yang berisi banyak nilai secara bertahap. Sedangkan `watch()` adalah metode yang memungkinkan kita untuk memantau perubahan pada koleksi notes. Setiap kali ada perubahan (misalnya, penambahan, pembaruan, atau penghapusan data), stream ini akan memperbarui dan mengirimkan data terbaru.
- Update Service
  ```dart
  Future<void> updateNote(int id, String title, String desc) async {
      final isar = await db;
      Note note = Note(id: id, title: title, note: desc);
      await isar.writeTxn(() => isar.notes.put(note));
  }
  ```
- Delete Service
  ```dart
  Future<void> deleteNote(int id) async {
      final isar = await db;
      await isar.writeTxn(() => isar.notes.delete(id));
  }
  ```
