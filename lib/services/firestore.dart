import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // We get the collection of new notes
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');
  // CREATE(Add a new note)
  Future<void> addNote(String nama, String asal) {
    return user.add({
      'asal': asal,
      'nama': nama,
    });
  }

  // READ(Get new notes from the database)
  Stream<QuerySnapshot> getNotesStream() {
    try {
      final notesStream =
          user.orderBy('nama', descending: true).snapshots();
      return notesStream;
    } catch (e) {
      print("Error getting notes stream: $e");
      throw e;
    }
  }

  // UPDATE(Update notes)
  Future<void> updateNote(String docId, String newNama, String newAsal) {
    return user.doc(docId).update({
      'nama': newNama,
      'asal': newAsal,
    });
  }

  // DELETE(Delete a note)
  Future<void> deleteNote(String Docid) {
    return user.doc(Docid).delete();
  }
}
