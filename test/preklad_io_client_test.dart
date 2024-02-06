import 'package:flutter_test/flutter_test.dart';

import 'package:preklad_io_client/preklad_io_client.dart';

void main() {
  // test('validate data translation', () async {
  //   final client = ApiClient.initialize(
  //     apiKey: 'YOUR_API_KEY',
  //     sourceLanguage: 'en',
  //     targetLanguage: 'cs',
  //   );

  //   final originalText = {
  //     'hello': 'Hello, World!',
  //     'goodbye': 'Goodbye, World!',
  //   };

  //   final result = await client.translateData(originalText);
  //   // print(result['hello']);
  //   var translatedText = client.getTranslationForKey('hello');
  //   identical(result['hello'], translatedText);
  // });

  test('validate text translation', () async {
    ApiClient.initialize(
      apiKey: 'YOUR_API_KEY',
      sourceLanguage: 'en',
      targetLanguage: 'cs',
    );

    const originalText = 'Hello!';
    final result = await ApiClient().translateText(originalText);

    expect(result, 'nejlepší překlad api!');
  });
}
