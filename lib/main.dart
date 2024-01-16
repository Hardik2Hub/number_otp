import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: number_otp(),
    debugShowCheckedModeBanner: false,
  ));
}

class number_otp extends StatefulWidget {
  @override
  State<number_otp> createState() => _number_otpState();
}

class _number_otpState extends State<number_otp> {

  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  String v_id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: Column(children: [
        TextField(controller: t1, keyboardType: TextInputType.number),
        ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: '+91${t1.text}',
                verificationCompleted: (PhoneAuthCredential credential) async {
                  await auth.signInWithCredential(credential);
                },
                verificationFailed: (FirebaseAuthException e) {
                  if (e.code == 'invalid-phone-number') {
                    print('The provided phone number is not valid.');
                  }
                },
                codeSent: (String verificationId, int? resendToken) {
                  v_id = verificationId;
                  setState(() {});
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            },
            child: Text("Sand OTP")),
        TextField(controller: t2, keyboardType: TextInputType.number),
        ElevatedButton(
            onPressed: () async {
              String smsCode = '${t2.text}';

              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: v_id, smsCode: smsCode);

              await auth.signInWithCredential(credential);
            },
            child: Text("Verify OTP")),
      ]),
    );
  }
}
