import 'package:assignment4/screens/client.dart';
import 'package:assignment4/screens/establishment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:assignment4/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = true;
  final email = TextEditingController();
  final password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void login() async {
    if (formkey.currentState!.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((userCredential) async {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Logging in',
        );
        String userID = userCredential.user!.uid;
        final document = await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .get();
        final data = document.data()!;
        Widget landing;
        if (data['type'] == 'client') {
         landing = ClientScreen(userID:userID);
        } else {
          landing = EstablishmentScreen();
        }

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => landing));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TraceIT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(22.5),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/trace-bg.jpg'),
                opacity: 0.1,
                fit: BoxFit.cover)),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email address';
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: password,
                obscureText: showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: toggleShowPassword),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                },
              ),
              const SizedBox(
                height: 29,
              ),
              //Login button
              ElevatedButton(
                onPressed: login,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(23.5),
                    backgroundColor: Color.fromARGB(255, 29, 89, 255)),
              ),
              const SizedBox(
                height: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
