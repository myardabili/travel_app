import 'package:flutter/material.dart';
import 'package:travel_app/features/destination/presentation/pages/dashboard.dart';

class AppRoute {
  static const dashboard = '/';
  static const detailDestination = '/destination/detail';
  static const searchDestination = '/destination/search';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (context) => const Dashboard());
      default:
        return _notFoundPage;
    }
  }

  static MaterialPageRoute get _notFoundPage => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      );
}
