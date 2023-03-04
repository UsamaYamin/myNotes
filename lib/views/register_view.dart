import 'package:firstapp/services/auth/auth_exceptions.dart';
import 'package:firstapp/services/auth/auth_service.dart';
import 'package:firstapp/utility/show_error.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(
                  verifyEmailRout,
                );
              } on WeakPasswordAuthException {
                await showError(context, 'Weak password');
              } on EmailAlreadyInUseAuthException {
                await showError(context, 'Email is already in use');
              } on InvalidEmailAuthException {
                await showError(context, 'Invalid email');
              } on GenericAuthException {
                await showError(context, 'Failed to register');
              }
              // on FirebaseAuthException catch (e) {
              //   if (e.code == 'weak-password') {

              //   } else if (e.code == 'email-already-in-use') {

              //   } else if (e.code == 'invalid-email') {
              //     await showError(context, 'Invalid email');
              //   } else {
              //     await showError(context, 'Error : ${e.code}');
              //   }
              // } catch (e) {

              // }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRout, (route) => false);
              },
              child: const Text("Already have an account? login"))
        ],
      ),
    );
  }
}
