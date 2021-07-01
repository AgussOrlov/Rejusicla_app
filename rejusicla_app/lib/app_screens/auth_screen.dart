import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rejusicla_app/app_screens/home_screen.dart';

import '../loading_widget.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  String _buttomText = "Login";
  String _swichText = "No tienes cuenta ? Registrate";

  bool _loading = false;

  void _validateFields() {
    if (_emailEditingController.text.isEmpty &&
        _passwordEditingController.text.isEmpty) {
      //porfavor Ingrese el email y la contraseña
      Fluttertoast.showToast(msg: "Porfavor Ingrese el Email y la Contraseña");
    } else if (_emailEditingController.text.isEmpty) {
      //porfavor ingrese el email
      Fluttertoast.showToast(msg: "Porfavor Ingrese el Email");
    } else if (_passwordEditingController.text.isEmpty) {
      //porfavor ingrese la contraseña
      Fluttertoast.showToast(msg: "Porfavor Ingrese la Contraseña");
    } else {
      setState(() {
        _loading = true;
      });

      if (_buttomText == "Login")
        _login();
      else
        _register();
    }
  }

  void _moveToHomeScreen() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _login() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailEditingController.text,
            password: _passwordEditingController.text)
        .then((UserCredential userCredential) {
      // ir a pantalla home

      setState(() {
        _loading = false;
      });

      Fluttertoast.showToast(msg: "Logueado Correctamente");

      _moveToHomeScreen();
    }).catchError((error) {
      // Mostrar error

      setState(() {
        _loading = false;
      });

      Fluttertoast.showToast(msg: error.toString());
    });
  }

  void _register() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailEditingController.text,
            password: _passwordEditingController.text)
        .then((UserCredential userCredential) {
      // ir a pantalla home
      setState(() {
        _loading = false;
      });

      Fluttertoast.showToast(msg: "Registrado Correctamente");
      _moveToHomeScreen();
    }).catchError((error) {
      // Mostrar error

      setState(() {
        _loading = false;
      });

      Fluttertoast.showToast(msg: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rejusicla App"),
      ),
      body: Container(
        /*decoration: new BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green.shade100, Colors.green.shade100])),*/
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Image.asset(
                    "assets/images/logoS.png",
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextField(
                    controller: _emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _passwordEditingController,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  _loading
                      ? circularProgress()
                      : GestureDetector(
                          onTap: _validateFields,
                          child: Container(
                            color: Colors.orange,
                            width: double.infinity,
                            height: 50.0,
                            child: Center(
                              child: Text(
                                _buttomText,
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_buttomText == "Login") {
                          _buttomText = "Register";
                          _swichText = "Ya tienes cuenta ? Inicia";
                        } else {
                          _buttomText = "Login";
                          _swichText = "No tienes cuenta ? Registrate";
                        }
                      });
                    },
                    textColor: Colors.red.shade700,
                    child: Text(
                      _swichText,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
