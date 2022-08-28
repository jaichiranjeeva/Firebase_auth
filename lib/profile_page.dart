import 'package:firebase_app/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({required this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        title: Text(' Hiii  ${_currentUser.displayName}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(
                          47, 248, 248, 248), //background color of button
                      side: const BorderSide(
                          width: 3,
                          color: Colors.white), //border width and color
                      elevation: 3, //elevation of button
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.all(
                          20) //content padding inside button
                      ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.login_rounded),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              heightFactor: 5,
              child: Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  '  Your E-Mail Adress: ',
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.start,
                ),
                Text("${_currentUser.email}")
              ],
            ),
            const SizedBox(height: 50.0),
            _currentUser.emailVerified
                ? Text(
                    'Email is already verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.green),
                  )
                : Text(
                    'Your Email is not yet verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.red),
                  ),
            const SizedBox(
              height: 20,
            ),
            _currentUser.emailVerified
                ? const Text("")
                : ElevatedButton(
                    onPressed: () async {
                      await _currentUser.sendEmailVerification();
                    },
                    child: const Text('Verify email'),
                  ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                User? user = await Authenticate.refreshUser(_currentUser);
                if (user != null) {
                  setState(() {
                    _currentUser = user;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
