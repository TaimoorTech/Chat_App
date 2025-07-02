import 'package:chat_app/core/common/custom_gradient_button.dart';
import 'package:chat_app/core/common/custom_text_field.dart';
import 'package:chat_app/core/utils/common_functions.dart';
import 'package:chat_app/core/utils/extensions.dart';
import 'package:chat_app/presentation/screens/auth/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../data/services/service_locator.dart';
import '../../../router/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = "Login";

  static Future<void> push() {
    return getIt<AppRouter>().navigateToFirstAppScreen(
      name: routeName,
      page: const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  bool isObscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Form(
        key: _loginFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                context.appLocalizations.welcome_back,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                context.appLocalizations.sign_in_to_continue,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                textEditingController: emailController,
                hintText: context.appLocalizations.general_email,
                focusNode: emailFocus,
                validator: CommonFunctions.validateEmail,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                textEditingController: passwordController,
                hintText: context.appLocalizations.general_password,
                obscureText: isObscurePassword,
                focusNode: passwordFocus,
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
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_loginFormKey.currentState?.validate() ?? false) {}
                },
                text: context.appLocalizations.login,
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                      text: "${context.appLocalizations.do_not_have_account}  ",
                      style: TextStyle(color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => SignupScreen.push(),
                          text: context.appLocalizations.sign_up,
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
