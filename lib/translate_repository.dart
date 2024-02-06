class TranslateRepository {
  final String url = 'https://api.preklad.io/api/translate';
  final Map<String, String> translations = {};
  String? _sourceLanguageCode;
  String? _targetLanguageCode;

  TranslateRepository();

  storeData(Map<String, String> data, String sourceLang, String targetLang) {
    _sourceLanguageCode = sourceLang;
    _targetLanguageCode = targetLang;

    data.forEach((key, value) {
      final textKey = _getKey(key, sourceLang, targetLang);
      translations[textKey] = value;
    });
  }

  storePlainData(String text, String sourceLang, String targetLang) {
    _sourceLanguageCode = sourceLang;
    _targetLanguageCode = targetLang;

    final textKey = _getTextKey(text, sourceLang, targetLang);
    translations[textKey] = text;
  }

  String? getTranslationForKey(String key, String? source, String? target) {
    final sourceLang = source ?? _sourceLanguageCode ?? 'en';
    final targetLang = target ?? _targetLanguageCode;
    if (targetLang == null) {
      throw "Target language code is not defined";
    }
    final textKey = _getKey(key, sourceLang, targetLang);
    return translations[textKey];
  }

  String? getTranslationForText(String text, String? source, String? target) {
    final sourceLang = source ?? _sourceLanguageCode ?? 'en';
    final targetLang = target ?? _targetLanguageCode;
    if (targetLang == null) {
      throw "Target language code is not defined";
    }
    final textKey = _getTextKey(text, sourceLang, targetLang);
    return translations[textKey];
  }

  String _getKey(String text, String source, String to) {
    return '$source-$to-$text';
  }

  String _getTextKey(String text, String source, String to) {
    return '$source-$to-${text.hashCode}';
  }
}
