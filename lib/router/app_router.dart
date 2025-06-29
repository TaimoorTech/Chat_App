import 'package:flutter/material.dart';

class AppRouter {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigatorKey.currentState!;

  void pop<T>([T? result]) {
    FocusManager.instance.primaryFocus?.unfocus();
    return _navigator.pop(result);
  }

  Future<T?> push<T>({required Widget page, String? name}) {
    FocusManager.instance.primaryFocus?.unfocus();
    return _navigator.push<T>(
      PageRouteBuilder(
        settings: RouteSettings(name: name),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Future<T?> pushReplacement<T>({required Widget page, String? name}) {
    FocusManager.instance.primaryFocus?.unfocus();
    return _navigator.pushReplacement<T, dynamic>(
      PageRouteBuilder(
        settings: RouteSettings(name: name),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Future<T?> navigateToFirstAppScreen<T>({required Widget page, String? name}) {
    FocusManager.instance.primaryFocus?.unfocus();
    return _navigator.pushAndRemoveUntil<T>(
      PageRouteBuilder(
        settings: RouteSettings(name: name),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      (route) => route.isFirst,
    );
  }

  Future<T?> pushAndRemoveUntil<T>({required Widget page, String? name}) {
    FocusManager.instance.primaryFocus?.unfocus();
    return _navigator.pushAndRemoveUntil<T>(
      PageRouteBuilder(
        settings: RouteSettings(name: name),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    FocusManager.instance.primaryFocus?.unfocus();
    return _navigator.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  void popUntil(String routeName) {
    FocusManager.instance.primaryFocus?.unfocus();
    _navigator.popUntil(ModalRoute.withName(routeName));
  }
}
