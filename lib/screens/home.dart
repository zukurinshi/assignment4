import 'package:assignment4/screens/login.dart';
import 'package:assignment4/screens/register_client.dart';
import 'package:assignment4/screens/register_establishment.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void Loginbtn () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  void RegisterCbtn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterClientScreen()));
  }
  void RegisterEbtn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterEstScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(22.5),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/trace-bg.jpg'),
              fit: BoxFit.cover,
              opacity: 0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'TraceIT',
                style: TextStyle(fontSize: 35.5),
              ),
            ),
            const SizedBox(
              height: 55.8,
            ),
            //Login button
            ElevatedButton(
              onPressed: Loginbtn,
              child: Text('Login',style: TextStyle(fontSize: 15.5),),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(22.5)),
            ),
             const SizedBox(
              height: 12.8,
            ),
            //Register client
            ElevatedButton(
              onPressed: RegisterCbtn,
              child: Text('Register as Client',style: TextStyle(fontSize: 15.5),),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(22.5)),
            ),
             const SizedBox(
              height: 12.8,
            ),
            //Register establishment
            ElevatedButton(
              onPressed: RegisterEbtn,
              child: Text('Register as Establishment',style: TextStyle(fontSize: 15.5),),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(22.5)),
            )
          ],
        ),
      )),
    );
  }
}
