import 'package:flutter/material.dart';
import 'package:preklad_io_client/preklad_io_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.initialize(apiKey: 'YOUR_API_KEY');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preklad.io Client Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
          title: 'Preklad.IO Client Example:  https://preklad.io'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _translatedText = '';
  final _textController = TextEditingController();
  bool _isInitialized = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    const textData = {
      'inputField': 'Enter text in English to translate',
      'button': 'Translate',
    };

    ApiClient()
        .translateData(textData,
            sourceLanguageCode: 'en', targetLanguageCode: 'es')
        .then((value) {
      setState(() {
        _isInitialized = true;
      });
    });
  }

  String getTextLabel() {
    return ApiClient().getTranslationForKey('inputField');
  }

  String getButtonText() {
    return ApiClient().getTranslationForKey('button');
  }

  buttonClickHandler() async {
    final text = _textController.text;
    final result = await ApiClient().translateText(text);

    setState(() {
      _translatedText = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // wait for translation data to be loaded
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: getTextLabel(),
              ),
            ),
            ElevatedButton(
              onPressed: buttonClickHandler,
              child: Text(getButtonText()),
            ),
            if (_translatedText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _translatedText,
                  locale: const Locale('es', 'ES'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
