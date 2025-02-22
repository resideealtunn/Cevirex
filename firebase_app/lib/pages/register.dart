import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;

  // Firebase Authentication ve Firestore işlemleri
  Future<void> registerUser(
      String email, String password, String fullName) async {
    try {
      // Kullanıcıyı Firebase Authentication ile kaydet
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı bilgileri al
      User? user = userCredential.user;

      if (user != null) {
        // Kullanıcıyı profil bilgisi ile güncelle
        await user.updateProfile(
            displayName: fullName); // İsim ve soyisim güncelleniyor

        // Firestore'a kullanıcı bilgilerini kaydet
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': fullName,
          'email': email,
          'correctCount': 0, // Başlangıçta doğru cevap sayısı 0
        });

        // Kayıt başarılı olduğunda mesaj göster
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarılı!')),
        );

        // Ana sayfaya veya giriş ekranına yönlendirme
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message; // Firebase'den gelen hata mesajı
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4D3),
      appBar: AppBar(
          title: const Text('Kayıt Ol'),
          backgroundColor: Color(0xFFE7235E),
          foregroundColor: Colors.white),
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

                // İsim Soyisim TextField
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'İsim Soyisim',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    iconColor: Color(0xFFACCAC8),
                    filled: true,
                    fillColor: Color(0xFFACCAC8),
                  ),
                ),
                const SizedBox(height: 20),

                // Email TextField
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    iconColor: Color(0xFFACCAC8),
                    filled: true,
                    fillColor: Color(0xFFACCAC8),
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
                    filled: true,
                    fillColor: Color(0xFFACCAC8),
                  ),
                ),

                const SizedBox(height: 30),

                // Hata Mesajı
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                // Kayıt Ol Butonu
                ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    String fullName = nameController.text.trim();

                    if (email.isNotEmpty &&
                        password.isNotEmpty &&
                        fullName.isNotEmpty) {
                      await registerUser(email, password, fullName);
                    } else {
                      print("Lütfen tüm alanları doldurun");
                    }
                  },
                  child: const Text('Kayıt Ol'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                    textStyle: TextStyle(fontSize: 18),
                    backgroundColor: Color(0xFFE7235E),
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
