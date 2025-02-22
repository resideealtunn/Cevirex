import 'dart:math';
import 'package:firebase_app/pages/packages.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WordApp extends StatefulWidget {
  final String category; // Seçilen kategori ('adverbs', 'verbs', 'names')
  const WordApp({super.key, required this.category});

  @override
  _WordAppState createState() => _WordAppState();
}

class _WordAppState extends State<WordApp> {
  List<Map<String, dynamic>> words = [];
  Map<String, dynamic>? selectedWord;
  int correctCount = 0;
  int wrongCount = 0;
  int ctrl = 0;
  final TextEditingController _controller = TextEditingController();
  bool isButtonDisabled = false;

  // Gösterilen kelimeleri saklamak için bir liste
  List<Map<String, dynamic>> shownWords = [];

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchWords() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(widget.category);
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        words = data.values.map((e) => Map<String, dynamic>.from(e)).toList();
        selectRandomWord();
      });
    } else {
      print("Kategori altında veri bulunamadı.");
    }
  }

  void selectRandomWord() {
    if (words.isNotEmpty) {
      final random = Random();

      // Gösterilen kelimelerden bir kelime seçmek için rastgele seçim yap
      List<Map<String, dynamic>> availableWords =
          words.where((word) => !shownWords.contains(word)).toList();

      if (availableWords.isNotEmpty) {
        setState(() {
          selectedWord = availableWords[random.nextInt(availableWords.length)];
          shownWords.add(selectedWord!); // Gösterilen kelimeyi listeye ekle
        });
      } else {
        // Eğer tüm kelimeler gösterildiyse, Packages sayfasına yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Packages()),
        );

        // Add the user's name to the "arrangement" collection after completing the game
        incrementCorrectCount();
      }
    }
  }

  void showRetryDialog(String correctAnswer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Yanlış Cevap"),
        content:
            Text("Doğru cevap: ${selectedWord!['english']}: $correctAnswer"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Uyarı kutusunu kapat
              setState(() {
                _controller.clear(); // Giriş alanını temizle
                // Aynı kelimeyi tekrar göster
              });
            },
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  Future<void> incrementCorrectCount() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Kullanıcının mevcut 'correctCount' değerini al
        final userSnapshot = await userDoc.get();

        if (userSnapshot.exists) {
          // 'correctCount' alanının mevcut olup olmadığını kontrol et
          final data = userSnapshot.data();
          int currentCount = data != null && data.containsKey('correctCount')
              ? data['correctCount'] ?? 0
              : 0;

          int newCount =
              currentCount + correctCount; // Mevcut değere ekleme yap

          await userDoc.update({
            'correctCount': newCount,
          });

          print("Correct count updated to: $newCount");
        } else {
          // Eğer kullanıcı kaydı yoksa yeni bir kayıt oluştur
          await userDoc.set({
            'name': user.displayName ?? 'Unnamed User',
            'email': user.email ?? 'No Email',
            'correctCount': correctCount, // İlk doğru sayısını ekle
          });

          print("New user added with correctCount: $correctCount");
        }
      } catch (e) {
        print("Error updating correctCount: $e");
      }
    } else {
      print("No user signed in.");
    }
  }

  Future<int> getCurrentCount() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userSnapshot = await userDoc.get();

        if (userSnapshot.exists) {
          // 'correctCount' alanının mevcut olup olmadığını kontrol et
          final data = userSnapshot.data();
          return data != null && data.containsKey('correctCount')
              ? data['correctCount'] ?? 0
              : 0;
        }
      } catch (e) {
        print("Error fetching correctCount: $e");
      }
    }

    return 0; // Kullanıcı yoksa veya hata varsa 0 döndür
  }

  @override
  void initState() {
    super.initState();
    fetchWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4D3),
      appBar: AppBar(
        title: Text('${widget.category.trim()} Kelimeleri'),
        backgroundColor: Color(0xFFE7235E),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Packages()),
            );
          },
        ),
      ),
      body: selectedWord == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Doğru: $correctCount",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // Doğru sayısı yeşil renk
                        ),
                      ),
                      Text(
                        "Yanlış: $wrongCount",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // Yanlış sayısı kırmızı renk
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    selectedWord!['english'],
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  selectedWord!['imageUrl'] != null
                      ? Image.network(selectedWord!['imageUrl'],
                          height: 200, width: 220)
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  Text(
                    selectedWord!['exampleSentenceEn'] ?? '',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    selectedWord!['exampleSentenceTr'] ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Türkçe karşılığını yazın",
                      iconColor: Color(0xFFACCAC8),
                      filled: true, // Arka planı doldurmak için
                      fillColor:
                          Color(0xFFACCAC8), // Arka plan rengini ayarlıyoruz
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: isButtonDisabled
                            ? null
                            : () {
                                if (_controller.text.trim().toLowerCase() ==
                                        selectedWord!['turkish']!
                                            .toLowerCase() &&
                                    ctrl == 0) {
                                  setState(() {
                                    correctCount++;
                                  });
                                  _controller.clear();
                                  selectRandomWord();
                                } else if (_controller.text
                                        .trim()
                                        .toLowerCase() !=
                                    selectedWord!['turkish']!.toLowerCase()) {
                                  setState(() {
                                    wrongCount++;
                                  });
                                  ctrl = 1;
                                  showRetryDialog(selectedWord!['turkish']);
                                } else {
                                  ctrl = 0;
                                  _controller.clear();
                                  selectRandomWord();
                                }
                              },
                        child: const Text("Onayla"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: Size(150, 50), // Buton boyutu
                          textStyle:
                              TextStyle(fontSize: 15), // Buton yazı boyutu
                          backgroundColor: Color(
                              0xFFE7235E), // Buton yazı rengini beyaz yapar
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isButtonDisabled
                            ? null
                            : () async {
                                setState(() {
                                  isButtonDisabled = true;
                                  _controller.text = selectedWord!['turkish'];
                                });

                                await Future.delayed(
                                    const Duration(seconds: 3));

                                setState(() {
                                  isButtonDisabled = false;
                                  _controller.clear();
                                  selectRandomWord();
                                });
                              },
                        child: const Text("Türkçesini Göster"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: Size(150, 50), // Buton boyutu
                          textStyle:
                              TextStyle(fontSize: 15), // Buton yazı boyutu
                          backgroundColor: Color(
                              0xFFE7235E), // Buton yazı rengini beyaz yapar
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
