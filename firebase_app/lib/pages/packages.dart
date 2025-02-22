import 'package:firebase_app/pages/app.dart';
import 'package:firebase_app/pages/arrangement.dart';
import 'package:flutter/material.dart';

class Packages extends StatelessWidget {
  const Packages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4D3),
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Geri gitmek için
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Image.asset(
                'assets/images/logo.png', // Logo dosya yolunu düzenleyin
                height: 40,
              ),
            ),
          ],
        ),
        title: const Text(
          'Paketler',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFE7235E), // Arka plan rengini ayarlıyoruz
        foregroundColor: Colors.white, // Ön plan rengi (yazı ve ikonlar beyaz)
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Arrangement()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // 'İsimler' kategorisini geçiyoruz
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordApp(category: 'names'),
                  ),
                );
              },
              child: const Text(
                'İsimler',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 100),
                backgroundColor: Color(0xFFE7235E),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 'Fiiller' kategorisini geçiyoruz
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordApp(category: 'verbs'),
                  ),
                );
              },
              child: const Text(
                'Fiiller',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 100),
                backgroundColor: Color(0xFFE7235E),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 'Zarflar' kategorisini geçiyoruz
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordApp(category: 'adverbs'),
                  ),
                );
              },
              child: const Text(
                'Zarflar',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 100),
                backgroundColor: Color(0xFFE7235E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
