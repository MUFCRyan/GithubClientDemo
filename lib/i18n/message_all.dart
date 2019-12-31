import 'package:github_client_demo/i18n/messages_messages.dart' as messages_messages;
import 'package:github_client_demo/i18n/messages_zh_CN.dart' as messages_zh_CN;
import 'package:intl/intl.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';
import 'package:intl/message_lookup_by_library.dart';

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'message': () => Future.value(null),
  'zh_CN': () => Future.value(null)
};

MessageLookupByLibrary _findExact(String localeName){
  switch(localeName){
    case 'messages':
      return messages_messages.messages;
    case 'zh_CN':
      return messages_zh_CN.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(localeName, (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return new Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? new Future.value(false) : lib());
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new Future.value(true);
}

bool _messagesExistFor(String locale){
  try{
    return _findExact(locale) != null;
  }catch (e){
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(String locale){
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
  if(actualLocale == null) return null;
  return _findExact(actualLocale);
}