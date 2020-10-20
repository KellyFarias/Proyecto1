import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:municipios/modelos/municipio.dart';
import 'package:municipios/screens/Authenticate/registro.dart';
import 'package:municipios/screens/Home/Administrador/onlyadmin.dart';
import 'package:municipios/screens/Home/General/principal.dart';
import 'package:municipios/servicios/auth.dart';
import 'package:municipios/servicios/database/db_usuarios.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Login Proyect 1'),
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _EmailPasswordForm(),
            // _EmailLinkSignInSection(),
            // _AnonymouslySignInSection(),
            // _PhoneSignInSection(Scaffold.of(context)),
            // _OtherProvidersSignInSection(),
          ],
        );
      }),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: const Text(
                    'Sign in with email and password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.center,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter some text';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter some text';
                    return null;
                  },
                  obscureText: true,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: SignInButton(
                    Buttons.Email,
                    text: "Sign In",
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        AuthService serviceauth = new AuthService();
                        dynamic result =
                            await serviceauth.signInWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text);
                        if (result.user.email != null) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(result.user.email + " signed in"),
                          ));
                          print('Ejecutar metodo');
                          String isAdmin = await DbUsuarios().isAdmin(result.user.uid);
                          print(isAdmin);
                          if (isAdmin.compareTo("Administrador") == 0) {
                            print("Page Admin");
                            _pushPage(context, ListViewMunicipiosAdmin());
                          } else {
                            print("Page Home");
                            _pushPage(context, ListViewMunicipios());
                          }
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Failed to sign in with Email & Password"),
                          ));
                        }
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: SignInButton(
                    Buttons.Email,
                    text: "Registro",
                    onPressed: () async {
                      _pushPage(context, RegisterPage());
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
