import 'package:flutter/material.dart';
import 'package:github_client_demo/common/funcs.dart';
import 'package:github_client_demo/common/git.dart';
import 'package:github_client_demo/common/global.dart';
import 'package:github_client_demo/i18n/localization_intl.dart';
import 'package:github_client_demo/models/user.dart';
import 'package:github_client_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginRouteState();
  }
}

class _LoginRouteState extends State<LoginRoute>{
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool _pwdShow = false;
  GlobalKey _formKey = GlobalKey();
  bool _unameAutoFocus = true;

  @override
  void initState() {
    _unameController.text = Global.profile.lastLogin;
    if(_unameController.text != null){
      _unameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.login),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: _unameAutoFocus,
                controller: _unameController,
                decoration: InputDecoration(
                  labelText: gm.userName,
                  hintText: gm.userName,
                  prefixIcon: Icon(Icons.person)
                ),
                validator: (v){
                  return v.trim().isNotEmpty ? null : gm.userNameRequired;
                },
              ),
              TextFormField(
                controller: _pwdController,
                autofocus: !_unameAutoFocus,
                decoration: InputDecoration(
                  labelText: gm.password,
                  hintText: gm.password,
                  prefixIcon: Icon(Icons.lock),
                  suffix: IconButton(
                    icon: Icon(_pwdShow ? Icons.visibility_off : Icons.visibility),
                    onPressed: (){
                      setState(() {
                        _pwdShow = !_pwdShow;
                      });
                    },
                  )
                ),
                obscureText: !_pwdShow,
                validator: (v){
                  return v.trim().isNotEmpty ? null : gm.passwordRequired;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _onLogin,
                    textColor: Colors.white,
                    child: Text(gm.login),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    if((_formKey.currentState as FormState).validate()){
      showLoading(context);
      User user;
      try{
        user = await Git(context).login(_unameController.text, _pwdController.text);
        Provider.of<UserModel>(context, listen: false).user = user;
      } catch(e){
        if(e.response?.statusCode == 401){
          showToast(GmLocalizations.of(context).userNameOrPasswordWrong);
        } else {
          showToast(e.toString());
        }
      } finally {
        Navigator.of(context).pop();
      }
      if(user != null){
        Navigator.of(context).pop();
      }
    }
  }
}