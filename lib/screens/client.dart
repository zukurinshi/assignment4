import 'package:assignment4/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key, required this.userID});
  final String userID;
  void signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TraceIT - Client',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => signout(context), icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: QrImageView(
          data: userID,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
