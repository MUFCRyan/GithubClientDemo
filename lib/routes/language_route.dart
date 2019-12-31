import 'package:flutter/material.dart';
import 'package:github_client_demo/i18n/localization_intl.dart';
import 'package:github_client_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class LanguageRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    var localModel = Provider.of<LocaleModel>(context);
    var gm = GmLocalizations.of(context);
    Widget _buildLanguageItem(String language, value){
      return ListTile(
        title: Text(language, style: TextStyle(color: localModel.locale == value ? color : null),),
        trailing: localModel.locale == value ? Icon(Icons.done, color: color,) : null,
        onTap: (){
          localModel.locale = value;
        },
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(gm.language),),
      body: ListView(
        children: <Widget>[
          _buildLanguageItem("中文简体", "zh_CN"),
          _buildLanguageItem("English", "en_US"),
          _buildLanguageItem(gm.auto, null)
        ],
      ),
    );
  }
}
