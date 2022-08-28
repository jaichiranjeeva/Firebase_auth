import 'package:firebase_app/Authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'validator.dart';
import 'register_page.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
        //primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            user: user,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        title: const Text('Authentication App'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            return Column(children: [
              const Center(
                heightFactor: 3,
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              Center(
                child: SizedBox(
                  width: 370,
                  height: 300,
                  child: Card(
                    color: const Color.fromARGB(234, 79, 75, 75),
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: SizedBox(
                      width: 300,
                      height: 240,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const Padding(padding: EdgeInsets.all(5)),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                ),
                                hintText: 'Your Email Adress',
                                labelText: 'Email',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              controller: _emailTextController,
                              // focusNode: _focusEmail,
                              validator: (value) =>
                                  Validator.validateEmail(email: value ?? "1"),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                labelStyle: TextStyle(color: Colors.white),
                                icon: Icon(
                                  Icons.password_sharp,
                                  color: Colors.white,
                                ),
                                hintText: '***',
                                labelText: 'Password',
                              ),
                              controller: _passwordTextController,
                              // focusNode: _focusPassword,
                              obscureText: true,
                              validator: (value) => Validator.validatePassword(
                                  password: value ?? "1"),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    // if (_formKey.currentState!.validate()) {
                                    User? user = await Authenticate
                                        .signInUsingEmailPassword(
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text,
                                      context: context,
                                    );
                                    if (user != null) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage(user: user)),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Dont have an account?Register Here',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
