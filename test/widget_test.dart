import 'package:flutter_test/flutter_test.dart';

import 'package:lulu_mvp_f/main.dart';

void main() {
  testWidgets('App launches with onboarding', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LuluApp());

    // Verify that welcome screen is shown
    expect(find.text('Lulu에 오신 것을\n환영해요!'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });
}
