import 'package:firebase_app/pages/login.dart';
import 'package:firebase_app/pages/register.dart';
import 'package:flutter/material.dart';

class Registerorlogin extends StatefulWidget {
  const Registerorlogin({super.key});

  @override
  State<Registerorlogin> createState() => _RegisterorloginState();
}

class _RegisterorloginState extends State<Registerorlogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WELCOME TO CEVRİLEX !"),
        centerTitle: true, // Başlığı ortalamak için
        backgroundColor: const Color(0xFFE7235E),
        foregroundColor: Colors.white,
      ),

      backgroundColor:
          Color(0xFFF8F4D3), // Arka plan rengini buradan ayarlıyoruz
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('assets/images/logo.png', height: 250),
            SizedBox(height: 50),

            // Giriş Yap butonu
            ElevatedButton(
              onPressed: () {
                // Giriş Yap butonuna tıklama işlevi
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text('Giriş Yap'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: Size(200, 50), // Buton boyutu
                textStyle: TextStyle(fontSize: 18), // Buton yazı boyutu
                backgroundColor:
                    Color(0xFFE7235E), // Buton yazı rengini beyaz yapar
              ),
            ),

            SizedBox(height: 20),

            // Kayıt Ol butonu
            ElevatedButton(
              onPressed: () {
                // Kayıt Ol butonuna tıklama işlevi
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: Text('Kayıt Ol'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: Size(200, 50), // Buton boyutu
                textStyle: TextStyle(fontSize: 18), // Buton yazı boyutu
                backgroundColor:
                    Color(0xFFE7235E), // Buton yazı rengini beyaz yapar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
