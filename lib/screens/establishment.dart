import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EstablishmentScreen extends StatelessWidget {
  const EstablishmentScreen({super.key});
  final collectionPath = 'logs';
  void scanQR(BuildContext context) async {
    Navigator.of(context).pop();
    final lineColor = '#ffffff';
    final cancelbtntext = 'CANCEL';
    final isShowFlashIcon = true;
    final scanMode = ScanMode.DEFAULT;
    String result = await FlutterBarcodeScanner.scanBarcode(
        lineColor, cancelbtntext, isShowFlashIcon, scanMode);
    print(result);
    if (result != '-1') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Registering',
        text: 'Please wait...',
      );
      await FirebaseFirestore.instance.collection(collectionPath).add({
        'client_uid': result,
        'establishment_uid': FirebaseAuth.instance.currentUser!.uid,
        'datetime': DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TraceIT - Establishment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(12.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () => scanQR(context), child: Text('Scan')),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(collectionPath)
                      .where('establishment_uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (_, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final documents = snapshots.data!.docs;
                    return ListView.builder(
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(documents[index]['client_uid'])
                                  .get(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                final document = snapshot.data!.data()!;
                                return Text(
                                    '${document['firstname']} ${document['lastname']}');
                              })),
                          subtitle:
                              Text(documents[index]['datetime'].toString()),
                        );
                      },
                      itemCount: documents.length,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
