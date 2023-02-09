import 'package:budget_app/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  bool isSignedIn = false;
  bool isObscure = true;
  Logger logger = Logger();

  List expensesName = [];
  List expensesAmount = [];
  List incomesName = [];
  List incomesAmount = [];

  //* Authentication
  Future<void> createUserWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    await _auth
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((_) => logger.d('Registration succesfull'))
        .onError(
      (error, _) {
        logger.d('Registration error: $error');
        DialogBox(
          context,
          error.toString().replaceAll(
                RegExp('\\[.*?\\]'),
                '',
              ),
        );
      },
    );
  }

  Future<void> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    await _auth
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((_) => logger.d('Login succesfull'))
        .catchError(
      (error) {
        logger.d('Login error: $error');
        DialogBox(
          context,
          error.toString().replaceAll(
                RegExp('\\[.*?\\]'),
                '',
              ),
        );
      },
    );
  }

  Future<void> signInWithGoogleMobile(
    BuildContext context,
  ) async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().onError(
              (error, _) => DialogBox(
                context,
                error.toString().replaceAll(
                      RegExp('\\[.*?\\]'),
                      '',
                    ),
              ),
            );

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _auth
        .signInWithCredential(credential)
        .then((_) => logger.d('Google Sign in successful'))
        .catchError(
      (error) {
        logger.d('Google Sign in error $error');
        DialogBox(
          context,
          error.toString().replaceAll(
                RegExp('\\[.*?\\]'),
                '',
              ),
        );
      },
    );
  }

  Future<void> signInWithGoogleWeb(
    BuildContext context,
  ) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

    await _auth
        .signInWithPopup(googleAuthProvider)
        .onError((error, stackTrace) => DialogBox(
              context,
              error.toString().replaceAll(
                    RegExp('\\[.*?\\]'),
                    '',
                  ),
            ));

    logger
        .d('Current user is not empty = ${_auth.currentUser!.uid.isNotEmpty}');
  }

  //* Check if Signed In
  Future<void> isLoggedIn() async {
    await _auth.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          isSignedIn = false;
        } else {
          isSignedIn = true;
        }
      },
    );
    notifyListeners();
  }

  //* Database
  Future<void> addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    TextEditingController controllerAmount = TextEditingController();
    TextEditingController controllerName = TextEditingController();

    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: const EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                text: 'Name',
                containerWidth: 130.0,
                hintText: 'Name',
                controller: controllerName,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                },
              ),
              const SizedBox(width: 10.0),
              TextForm(
                text: 'Amount',
                containerWidth: 100.0,
                hintText: 'Amount',
                controller: controllerAmount,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            color: Colors.black,
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                userCollection
                    .doc(_auth.currentUser?.uid)
                    .collection('expenses')
                    .add({
                  'name': controllerName.text,
                  'amount': controllerAmount.text,
                }).then((_) {
                  logger.d('Expense added');
                }).onError((error, _) {
                  logger.d('Add expense error: $error');
                  return DialogBox(
                    context,
                    error.toString(),
                  );
                });
                Navigator.pop(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            splashColor: Colors.grey,
            child: const OpenSans(
              color: Colors.white,
              text: 'Save',
              size: 15.0,
            ),
          )
        ],
      ),
    );
  }

  Future<void> addIncome(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    TextEditingController controllerAmount = TextEditingController();
    TextEditingController controllerName = TextEditingController();

    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: const EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                text: 'Name',
                containerWidth: 130.0,
                hintText: 'Name',
                controller: controllerName,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                },
              ),
              const SizedBox(width: 10.0),
              TextForm(
                text: 'Amount',
                containerWidth: 100.0,
                hintText: 'Amount',
                controller: controllerAmount,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            color: Colors.black,
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                userCollection
                    .doc(_auth.currentUser?.uid)
                    .collection('incomes')
                    .add({
                  'name': controllerName.text,
                  'amount': controllerAmount.text,
                }).then((_) {
                  logger.d('Income added');
                }).onError((error, _) {
                  logger.d('Add income error: $error');
                  return DialogBox(
                    context,
                    error.toString(),
                  );
                });
                Navigator.pop(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            splashColor: Colors.grey,
            child: const OpenSans(
              color: Colors.white,
              text: 'Save',
              size: 15.0,
            ),
          )
        ],
      ),
    );
  }

  void expensesStream() async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser?.uid)
        .collection('expenses')
        .snapshots()) {
      expensesAmount = [];
      expensesName = [];

      for (var expense in snapshot.docs) {
        expensesName.add(expense.data()['name']);
        expensesAmount.add(expense.data()['amount']);
        notifyListeners();
      }
    }
  }

  void incomesStream() async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser?.uid)
        .collection('incomes')
        .snapshots()) {
      incomesAmount = [];
      incomesName = [];

      for (var income in snapshot.docs) {
        incomesName.add(income.data()['name']);
        incomesAmount.add(income.data()['amount']);
        notifyListeners();
      }
    }
  }

  Future<void> reset() async {
    await userCollection
        .doc(_auth.currentUser?.uid)
        .collection('expenses')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot document in snapshot.docs) {
        document.reference.delete();
      }
    });

     await userCollection
        .doc(_auth.currentUser?.uid)
        .collection('incomes')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot document in snapshot.docs) {
        document.reference.delete();
      }
    });
  }

  //* Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  void toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }
}
