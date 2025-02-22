import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'packages.dart'; // Packages ekranını içeren dosyanızı import edin.

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Giriş başarılıysa packages.dart ekranına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Packages()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message; // Hata mesajını ekranda göster
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4D3),
      appBar: AppBar(
        title: const Text('Giriş Yap'),
        backgroundColor: Color(0xFFE7235E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                ),
                const SizedBox(height: 40),

                // Email TextField
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    iconColor: Color(0xFFACCAC8),
                    filled: true, // Arka planı doldurmak için
                    fillColor:
                        Color(0xFFACCAC8), // Arka plan rengini ayarlıyoruz
                  ),
                ),
                const SizedBox(height: 20),

                // Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    iconColor: Color(0xFFACCAC8),
                    filled: true, // Arka planı doldurmak için
                    fillColor:
                        Color(0xFFACCAC8), // Arka plan rengini ayarlıyoruz
                  ),
                ),
                const SizedBox(height: 20),

                // Hata Mesajı
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 20),

                // Giriş Yap Butonu
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: const Text('Giriş Yap'),
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
        ),
      ),
    );
  }
}