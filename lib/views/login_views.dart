import 'package:firstapp/services/auth/auth_exceptions.dart';
import 'package:firstapp/utility/show_error.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../services/auth/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRout,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRout,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showError(context, 'User not found');
              } on WrongPasswordAuthException {
                await showError(context, 'Wrong password');
              } on GenericAuthException {
                await showError(context, 'Authentication Error');
              }
              // on FirebaseAuthException catch (e) {
              //   if (e.code == 'user-not-found') {
              //     // devtools.log('User not found');

              //   } else if (e.code == 'wrong-password') {
              //     // devtools.log('wrong password');

              //   } else {
              //     await showError(context, 'Error: ${e.code}');
              //   }
              // } catch (e) {

              // }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRout, (route) => false);
              },
              child: const Text("Register if you don't have an account"))
        ],
      ),
    );
  }
}
