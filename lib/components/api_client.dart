import 'package:flutter/foundation.dart';

import './http_client.dart';
import '../language_codes.dart';
import '../translate_repository.dart';

class ApiClient {
  static ApiClient? _instance;
  final TranslateRepository _repository;
  final HttpApiClient _httpClient;

  @protected
  final String apiKey;

  // sourceLanguage: original language code
  String? sourceLanguage;
  // targetLanguage:  language code to be translated to
  String? targetLanguage;

  // Initialize ApiClient instance
  static ApiClient initialize({
    required String apiKey,
    String? sourceLanguage,
    String? targetLanguage,
  }) {
    return _instance = ApiClient._internal(
      apiKey: apiKey,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  // Get ApiClient already initialized
  factory ApiClient() {
    assert(_instance != null);
    return _instance!;
  }

  ApiClient._internal({
    required this.apiKey,
    required this.sourceLanguage,
    required this.targetLanguage,
  })  : _repository = TranslateRepository(),
        _httpClient = HttpApiClient(apiKey);

  // translate data with key-value pairs Map<String, String>
  // sourceLanguageCode: original language code,  'en' is used by default
  // targetLanguageCode: language code to be translated to
  // returns Map<String, String> with translated data
  Future<Map<String, String>> translateData(Map<String, String> data,
      {String? sourceLanguageCode,
      String? targetLanguageCode,
      List<String>? ignoreWords}) async {
    if (data.isEmpty) {
      throw "Input data should not be empty";
    }

    final source = _getSourceLanguage(sourceLanguageCode);
    final target = _getTargetLanguage(targetLanguageCode);
    final ignore = ignoreWords ?? [];

    final result = await _httpClient.performDataTranslationRequest(
        data, source, target, ignore);

    // store in cache
    _repository.storeData(result, source, target);

    return result;
  }

  // get translation for previously translated data from cache
  // key: ket of key-value pair map
  // sourceLanguageCode: original language code,  previous source language is used in case of null
  // targetLanguageCode: language code to be translated to, previous target language is used in case of null
  // returns translated string or original key if translation is not found
  String getTranslationForKey(String key,
      {String? sourceLanguageCode, String? targetLanguageCode}) {
    if (key.isEmpty) {
      throw "Key for key-value transalton pair should not be empty";
    }

    final source = _getSourceLanguage(sourceLanguageCode);
    final target = _getTargetLanguage(targetLanguageCode);

    final result = _repository.getTranslationForKey(key, source, target);

    if (result == null) {
      // translation is not found in cache return original key
      return key;
    }

    return result;
  }

  // translate plain text
  // text - text to be translated
  // sourceLanguageCode: original language code,  'en' is used by default
  // targetLanguageCode: language code to be translated to
  // returns translated text or throws an error if translation fails
  Future<String> translateText(String text,
      {String? sourceLanguageCode,
      String? targetLanguageCode,
      List<String>? ignoreWords}) async {
    final source = _getSourceLanguage(sourceLanguageCode);
    final target = _getTargetLanguage(targetLanguageCode);
    final ignore = ignoreWords ?? [];

    if (text.isEmpty) {
      throw "Input text should not be empty";
    }

    // check if text is already translated
    final result = _repository.getTranslationForText(text, source, target);
    if (result != null) {
      return result;
    }

    // translate text
    final translatedText = await _httpClient.performTextTranslationRequest(
        text, source, target, ignore);

    if (translatedText == null) {
      throw "Failed to translate text";
    }

    // store in cache
    _repository.storePlainData(translatedText, source, target);

    return translatedText;
  }

  String _getSourceLanguage(String? sourceLanguageCode) {
    final source = sourceLanguageCode ?? sourceLanguage ?? 'en';

    if (!LangugageCodes.isExist(source)) {
      throw "Unsupported source language code: $source";
    }

    sourceLanguage = source;

    return source;
  }

  String _getTargetLanguage(String? targetLanguageCode) {
    final target = targetLanguageCode ?? targetLanguage;

    if (target == null) {
      throw "Target language code is not defined";
    }

    if (!LangugageCodes.isExist(target)) {
      throw "Unsupported targegt language code: $target";
    }

    targetLanguage = target;
    return target;
  }
}
