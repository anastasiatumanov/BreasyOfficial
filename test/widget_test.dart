// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testing/main.dart';

void main() {
  testWidgets('Basic test', (WidgetTester tester) async {
  // Build a minimal test widget
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Text('Test App'), // Replace with your actual content
    ),
  ));
  
  expect(find.text('Test App'), findsOneWidget); // Verify something exists
});
}
