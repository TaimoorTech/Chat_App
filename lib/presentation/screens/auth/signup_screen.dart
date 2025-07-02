import 'package:chat_app/core/utils/common_functions.dart';
import 'package:chat_app/core/utils/extensions.dart';
import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:chat_app/data/services/service_locator.dart';
import 'package:chat_app/presentation/screens/auth/login_screen.dart';
import 'package:chat_app/router/app_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/common/custom_gradient_button.dart';
import '../../../core/common/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const routeName = "Signup";

  static Future<void> push() {
    return getIt<AppRouter>().push(
      name: routeName,
      page: const SignupScreen(),
    );
  }

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupFormKey = GlobalKey<FormState>();

  bool isObscurePassword = true;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final nameFocus = FocusNode();
  final usernameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your full name";
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your username";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number (e.g., +1234567890)';
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();

    nameFocus.dispose();
    usernameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  Future<void> handleSignUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_signupFormKey.currentState?.validate() ?? false) {
      try {
        await getIt<AuthRepository>().signUp(
          username: usernameController.text,
          fullName: nameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
          password: passwordController.text,
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: Form(
            key: _signupFormKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    context.appLocalizations.create_account,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.appLocalizations.fill_in_details,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    textEditingController: nameController,
                    hintText: context.appLocalizations.full_name,
                    focusNode: nameFocus,
                    validator: validateName,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    textEditingController: usernameController,
                    hintText: context.appLocalizations.username,
                    focusNode: usernameFocus,
                    validator: validateUsername,
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    textEditingController: emailController,
                    hintText: context.appLocalizations.general_email,
                    focusNode: emailFocus,
                    validator: CommonFunctions.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    textEditingController: phoneController,
                    hintText: context.appLocalizations.phone_number,
                    focusNode: phoneFocus,
                    validator: validatePhone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    textEditingController: passwordController,
                    hintText: context.appLocalizations.general_password,
                    obscureText: isObscurePassword,
                    focusNode: passwordFocus,
                    validator: CommonFunctions.validatePassword,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        isObscurePassword = !isObscurePassword;
                      },
                      child: isObscurePassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomGradientButton(
                    onPressed: () => handleSignUp(context),
                    text: context.appLocalizations.create_account,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: " ",
                          style: TextStyle(color: Colors.grey[600]),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  LoginScreen.push();
                                },
                              text: context.appLocalizations.login,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
