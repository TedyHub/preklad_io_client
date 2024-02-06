import '../components/api_client.dart';

extension Translate on String {
  // Translate your text from source to target language
  Future<String> translate({
    String? sourceLanguage,
    String? targetLanguage,
  }) {
    return ApiClient().translateText(
      this,
      sourceLanguageCode: sourceLanguage,
      targetLanguageCode: targetLanguage,
    );
  }
}
