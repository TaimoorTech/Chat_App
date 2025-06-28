import 'package:flutter/material.dart';

Future<T?> pushMaterialPageRoute<T>(
  final BuildContext context, {
  required final String? name,
  required final WidgetBuilder builder,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  return Navigator.push<T>(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: name),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

Future pushReplacementMaterialPageRoute<T>(
  final BuildContext context, {
  required final String? name,
  required final WidgetBuilder builder,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  return Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: name),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

Future<void> navigateToFirstAppScreen(
  final BuildContext context, {
  required final WidgetBuilder builder,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: builder,
    ),
    (route) => route.isFirst, // Keep only the first route
  );
}

Future<void> pushAndRemoveUntil(
  final BuildContext context, {
  required final WidgetBuilder builder,
}) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: builder,
    ),
    (route) => false, // Keep only the first route
  );
}

void popUntil(final BuildContext context, {required String route}) {
  return Navigator.popUntil(context, ModalRoute.withName(route));
}
