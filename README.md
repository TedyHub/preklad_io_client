Prekla.IO  API  service.
The package is designed to to work with translate API service  https://preklad.io

## Features
It allows to translate on-demand map of key-value pair  or simple text messages. 
Result of translation is stored in cache to reduce  network requests.

## Getting started

Add preklad_io_client to your pubspec:
```yaml
dependencies:
  preklad_io_client: any # or the latest version on Pub
```

Obtain  API_KEY from  Preklad.IO service (https://preklad.io).


## Usage


Configure the client:
```dart
ApiClient.initialize(
      apiKey: 'YOUR_API_KEY',
      sourceLanguage: 'en',
      targetLanguage: 'cs',
    );
```

Translate  plain text message:

```dart
final result = await ApiClient().translateText(text);
```

Translate key-value pair map:
```dart
const textData = {
    'inputField': 'Enter text in English to translate',
    'button': 'Translate',
};
await ApiClient().translateData(textData)
```

Use trannslated data any time  by key:

```dart
ApiClient().getTranslationForKey('inputField');
```

## Run the example
See the `example/` folder for a working example app.

