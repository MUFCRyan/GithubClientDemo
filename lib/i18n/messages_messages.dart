import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageOfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary{
  @override
  String get localeName => 'messages';

  @override
  Map<String, Function> get messages => _notInLinedMessages(_notInLinedMessages);

  static _notInLinedMessages(_) => <String, Function>{
    "auto" : MessageLookupByLibrary.simpleMessage("Auto"),
    "cancel" : MessageLookupByLibrary.simpleMessage("cancel"),
    "home" : MessageLookupByLibrary.simpleMessage("Github"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "login" : MessageLookupByLibrary.simpleMessage("Login"),
    "logout" : MessageLookupByLibrary.simpleMessage("logout"),
    "logoutTip" : MessageLookupByLibrary.simpleMessage("Are you sure you want to quit your current account?"),
    "noDescription" : MessageLookupByLibrary.simpleMessage("No description yet !"),
    "password" : MessageLookupByLibrary.simpleMessage("Password"),
    "passwordRequired" : MessageLookupByLibrary.simpleMessage("Password required!"),
    "setting" : MessageLookupByLibrary.simpleMessage("Setting"),
    "theme" : MessageLookupByLibrary.simpleMessage("Theme"),
    "title" : MessageLookupByLibrary.simpleMessage("Flutter APP"),
    "userName" : MessageLookupByLibrary.simpleMessage("User Name"),
    "userNameOrPasswordWrong" : MessageLookupByLibrary.simpleMessage("User name or password is not correct!"),
    "userNameRequired" : MessageLookupByLibrary.simpleMessage("User name required!"),
    "yes" : MessageLookupByLibrary.simpleMessage("yes")
  };
}