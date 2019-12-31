import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_client_demo/common/global.dart';
import 'package:github_client_demo/i18n/localization_intl.dart';
import 'package:github_client_demo/routes/home_page.dart';
import 'package:github_client_demo/routes/language_route.dart';
import 'package:github_client_demo/routes/login_route.dart';
import 'package:github_client_demo/routes/theme_change_route.dart';
import 'package:github_client_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:github_client_demo/string_apis.dart' hide NumberParsing;
import 'package:github_client_demo/string_apis_2.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MyApp()));
  print("2".parseInt());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocaleModel())
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child){
          return MaterialApp(
            theme: ThemeData(primarySwatch: themeModel.theme),
            onGenerateTitle: (context) {
              var gm = GmLocalizations.of(context);
              return gm.title;
            },
            home: HomeRoute(),
            locale: localeModel.getLocale(),
            supportedLocales: [ const Locale('en', 'US'), const Locale('zn', 'CN') ],
            localizationsDelegates: [
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GmLocalizationsDelegate()
            ],
            localeResolutionCallback: (Locale _locale, Iterable<Locale> supportedLocales){
              if(localeModel.getLocale() != null){
                return localeModel.getLocale();
              } else {
                Locale locale;
                //APP语言跟随系统语言，如果系统语言不是中文简体或美国英语，
                //则默认使用美国英语
                if(supportedLocales.contains(_locale)){
                  locale = _locale;
                } else {
                  locale = Locale('en', "US");
                }
                return locale;
              }
            },

            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(),
              "themes": (context) => ThemeChangeRoute(),
              "language": (context) => LanguageRoute(),
            },
          );
        },
      ),
    );
  }
}