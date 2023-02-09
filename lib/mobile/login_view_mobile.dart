import 'package:budget_app/components.dart';
import 'package:budget_app/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class LoginViewMobile extends HookConsumerWidget {
  const LoginViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ViewModel viewModelProvider = ref.watch(viewModel);
    final double deviceHeight = MediaQuery.of(context).size.height;

    TextEditingController emailField = useTextEditingController();
    TextEditingController passwordField = useTextEditingController();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: deviceHeight / 5.5),
              Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                width: 210.0,
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  controller: emailField,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hintText: 'Email',
                    hintStyle: GoogleFonts.openSans(),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 30.0,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  controller: passwordField,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle: GoogleFonts.openSans(),
                    prefixIcon: IconButton(
                      icon: Icon(
                        viewModelProvider.isObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      onPressed: () {
                        viewModelProvider.toggleObscure();
                      },
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: viewModelProvider.isObscure,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.0,
                    width: 150.0,
                    child: MaterialButton(
                      color: Colors.black,
                      onPressed: () async {
                        await viewModelProvider.createUserWithEmailAndPassword(
                          context,
                          emailField.text,
                          passwordField.text,
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      splashColor: Colors.grey,
                      child: const OpenSans(
                        color: Colors.white,
                        text: 'Register',
                        size: 25.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Text(
                    'Or',
                    style: GoogleFonts.pacifico(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  SizedBox(
                    height: 50.0,
                    width: 150.0,
                    child: MaterialButton(
                      color: Colors.black,
                      onPressed: () async {
                        await viewModelProvider.signInWithEmailAndPassword(
                          context,
                          emailField.text,
                          passwordField.text,
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      splashColor: Colors.grey,
                      child: const OpenSans(
                        color: Colors.white,
                        text: 'Login',
                        size: 25.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              SignInButton(
                buttonSize: ButtonSize.medium,
                buttonType: ButtonType.googleDark,
                onPressed: () async {
                  if (kIsWeb) {
                    await viewModelProvider.signInWithGoogleWeb(context);
                  } else {
                    await viewModelProvider.signInWithGoogleMobile(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
