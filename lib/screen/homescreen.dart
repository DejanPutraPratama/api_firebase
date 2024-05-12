import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:api_firebase/services/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController asalController = TextEditingController();

  void openBox({String? docId, String? initialNama, String? initialAsal}) {
    if (docId != null) {
      namaController.text = initialNama ?? "";
      asalController.text = initialAsal ?? "";
    } else {
      namaController.clear();
      asalController.clear();
    }

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? 'Add Data' : 'Update Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Masukkan Nama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: asalController,
              decoration: InputDecoration(
                labelText: 'Masukkan Asal',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaController.text.isNotEmpty && asalController.text.isNotEmpty) {
                if (docId == null) {
                  firestoreService.addNote(namaController.text, asalController.text);
                } else {
                  firestoreService.updateNote(docId, namaController.text, asalController.text);
                }
                Navigator.pop(context);
              } else {
                // Tambahkan penanganan kesalahan jika diperlukan
              }
            },
            child: Text(docId == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Your Data",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openBox(),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List userList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = userList[index];
                String docId = document.id ?? "";

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic> ?? {};
                String nama = data['nama'] ?? "";
                String asal = data['asal'] ?? "";

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(16),
                  child: ListTile(
                    title: Text("$nama ($asal)"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => firestoreService.deleteNote(docId),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () => openBox(docId: docId),
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
