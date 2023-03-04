import 'package:firstapp/constants/routes.dart';
import 'package:firstapp/firebase_options.dart';
import 'package:firstapp/services/auth/auth_service.dart';
import 'package:firstapp/views/login_views.dart';
import 'package:firstapp/views/notes_view.dart';
import 'package:firstapp/views/register_view.dart';
import 'package:firstapp/views/verify_email.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        loginRout: (context) => const LoginView(),
        registerRout: (context) => const RegisterView(),
        notesRout: (context) => const NotesView(),
        verifyEmailRout: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log('Email is verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const NotesView();
          // return const LoginView();

          default:
            return const CircularProgressIndicator();
        }
      }),
    );
  }
}
