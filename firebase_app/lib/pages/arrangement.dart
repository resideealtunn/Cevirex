import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/pages/packages.dart';
import 'package:flutter/material.dart';

class Arrangement extends StatefulWidget {
  const Arrangement({super.key});

  @override
  State<Arrangement> createState() => _ArrangementState();
}

class _ArrangementState extends State<Arrangement> {
  List<Map<String, dynamic>> users = [];

  // Kullanıcıları fetch etmek
  Future<void> fetchUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('correctCount',
              descending: true) // Doğru sayısına göre sıralama
          .get();

      if (snapshot.docs.isEmpty) {
        print("Veri bulunamadı.");
      }

      setState(() {
        users = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['name'],
            'email': doc['email'],
            'correctCount': doc['correctCount'] ?? 0, // Varsayılan olarak 0
          };
        }).toList();
      });
    } catch (e) {
      print("Hata: $e");
    }
  }

  // Kullanıcının doğru sayısını güncellemek
  Future<void> updateCorrectCount(String userId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.update({
      'correctCount': FieldValue.increment(1), // Doğru sayısını artır
    });

    fetchUsers(); // Güncel kullanıcı listesini tekrar getir
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Sayfa yüklendiğinde kullanıcıları getir
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında packages sayfasına yönlendirme
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Packages()),
        );
        return false; // Default geri işlemi engelleniyor
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F4D3),
        appBar: AppBar(
          title: const Text('Başarı Listesi'),
          backgroundColor: const Color(0xFFE7235E),
          foregroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Geri tuşuna basıldığında packages sayfasına yönlendir
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Packages()),
              );
            },
          ),
        ),
        body: users.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(
                      user['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Yazıyı kalın yapar
                      ),
                    ),
                    subtitle: Text(user['email']),
                    trailing: Text(
                      'Doğru: ${user['correctCount']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Yazıyı kalın yapar
                      ),
                    ),
                    onTap: () {
                      // Kullanıcıya tıkladığında doğru sayısını artır
                      updateCorrectCount(user['id']);
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black, // Siyah çizgi rengi
                  thickness: 1, // Çizgi kalınlığı
                ),
              ),
      ),
    );
  }
}
