import 'package:flutter/material.dart';
import 'package:github_client_demo/common/global.dart';
import 'package:github_client_demo/i18n/localization_intl.dart';
import 'package:github_client_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class ThemeChangeRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(GmLocalizations.of(context).theme),),
      body: ListView(
        children: Global.themes.map<Widget>((e){
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: Container(color: e, height: 40,),
            ),

            onTap: (){
              Provider.of<ThemeModel>(context).theme = e;
            },
          );
        }).toList()
      ),
    );
  }
}