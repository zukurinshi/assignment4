import 'package:assignment4/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegisterClientScreen extends StatefulWidget {
  const RegisterClientScreen({super.key});

  @override
  State<RegisterClientScreen> createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  bool showPassword = true;
  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  void register() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Register account?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.blue,
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        registerClient();
      },
    );
  }

  void registerClient() async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Registering',
      text: 'Please wait...',
    );
    try {
      UserCredential userCredential = 
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
          String user_id = userCredential.user!.uid;
          await FirebaseFirestore.instance.collection('users').doc(user_id).set({
            'firstname':firstName.text,
            'middlename':middleName.text,
            'lastname':lastName.text,
            'address':address.text,
            'email':email.text,
            'type':'client'
          });
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>LoginScreen()));
    } on FirebaseAuthException catch (exception) {
      Navigator.of(context).pop();
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Registration failed',
          text: 'Email is already in use');
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
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(22.5),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/trace-bg.jpg'),
                    opacity: 0.1,
                    fit: BoxFit.cover)),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //First name
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                    },
                    controller: firstName,
                    decoration: InputDecoration(
                        labelText: 'First name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 18.5,
                  ),
                  //Middle name
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                    },
                    controller: middleName,
                    decoration: InputDecoration(
                        labelText: 'Middle name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 18.5,
                  ),
                  //Last name
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                    },
                    controller: lastName,
                    decoration: InputDecoration(
                        labelText: 'Last name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 18.5,
                  ),
                  //Address
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                    },
                    controller: address,
                    decoration: InputDecoration(
                        labelText: 'Address', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 18.5,
                  ),

                  //Email
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                    },
                    controller: email,
                    decoration: InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 18.5,
                  ),
                  //Password
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                    },
                    obscureText: showPassword,
                    controller: password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: toggleShowPassword,
                          icon: Icon(showPassword
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                  ),
                  const SizedBox(
                    height: 18.5,
                  ),

                  //Confirm Password
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (password.text != value) {
                        return 'Passwords do not match';
                      }
                    },
                    obscureText: showPassword,
                    controller: confirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: toggleShowPassword,
                          icon: Icon(showPassword
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                  ),

                  const SizedBox(
                    height: 18.5,
                  ),
                  //Register button
                  ElevatedButton(
                    onPressed: register,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(23.5),
                        backgroundColor: Color.fromARGB(255, 29, 89, 255)),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
