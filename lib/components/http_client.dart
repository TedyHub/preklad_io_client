import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpApiClient {
  final String baseUrl = 'https://api.preklad.io/api/translate';
  final String apiKey;

  HttpApiClient(this.apiKey);

  Future<Map<String, String>> performDataTranslationRequest(
      Map<String, String> data,
      String sourceLang,
      String targetLang,
      List<String> ignoreWords) async {
    final apiUrl = Uri.parse('$baseUrl/json');

    var response = await http.post(apiUrl,
        headers: _getJsonRequestHeader(sourceLang, targetLang, ignoreWords),
        body: jsonEncode(data));
    if (response.statusCode != 202) {
      var errorResponseMap = jsonDecode(response.body) as Map<String, dynamic>;

      throw Exception(
          'Failed to translate data: ErrorCode: ${errorResponseMap['errorCode']}, ErrorMessage: ${errorResponseMap['message']}');
    }

    var responseMap = jsonDecode(response.body) as Map<String, dynamic>;
    var result = responseMap['data'] as Map<String, dynamic>;

    // convert to Map<String, String>
    var stringMap = <String, String>{};
    result.forEach((key, value) {
      stringMap[key] = value as String;
    });
    return stringMap;
  }

  Future<String?> performTextTranslationRequest(String text, String sourceLang,
      String targetLang, List<String> ignoreWords) async {
    final apiUrl = Uri.parse('$baseUrl/text');
    final response = await http.post(apiUrl,
        headers: _getTextRequestHeader(sourceLang, targetLang, ignoreWords),
        body: text);

    if (response.statusCode != 202) {
      var errorResponseMap = jsonDecode(response.body) as Map<String, dynamic>;

      throw Exception(
          'Failed to translate text: ErrorCode: ${errorResponseMap['errorCode']}, ErrorMessage: ${errorResponseMap['message']}');
    }

    var result = utf8.decode(response.bodyBytes);
    return result;
  }

  Map<String, String> _getJsonRequestHeader(
      String from, String to, List<String> ignoreWords) {
    if (apiKey.isEmpty) {
      throw Exception('API Key is not defined. Please define API Key.');
    }
    if (from.isEmpty) {
      throw Exception('Source language code is not defined.');
    }

    if (to.isEmpty) {
      throw Exception('Target language code is not defined.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Key': apiKey,
      'X-From': from,
      'X-To': to
    };

    if (ignoreWords.isNotEmpty) {
      headers['X-Ignore'] = ignoreWords.join(',');
    }

    return headers;
  }

  Map<String, String> _getTextRequestHeader(
      String from, String to, List<String> ignoreWords) {
    if (apiKey.isEmpty) {
      throw Exception('API Key is not defined. Please define API Key.');
    }
    if (from.isEmpty) {
      throw Exception('Source language code is not defined.');
    }

    if (to.isEmpty) {
      throw Exception('Target language code is not defined.');
    }

    final headers = {'X-Key': apiKey, 'X-From': from, 'X-To': to};

    if (ignoreWords.isNotEmpty) {
      headers['X-Ignore'] = ignoreWords.join(',');
    }

    return headers;
  }
}
