import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:github_client_demo/common/funcs.dart';
import 'package:github_client_demo/common/git.dart';
import 'package:github_client_demo/i18n/localization_intl.dart';
import 'package:github_client_demo/models/repo.dart';
import 'package:github_client_demo/states/profile_change_notifier.dart';
import 'package:github_client_demo/widgets/repo_item.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute([String name, String value]):super();
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(GmLocalizations.of(context).home),),
      body: _buildBody(),
      drawer: MyDrawer(),
    );
  }

  Widget _buildBody(){
    UserModel model = Provider.of<UserModel>(context);
    if(!model.isLogin){
      return Center(
        child: RaisedButton(
          child: Text(GmLocalizations.of(context).login),
            onPressed: () => Navigator.of(context).pushNamed("login")
        ),
      );
    } else {
      return InfiniteListView(
          onRetrieveData: (int page, List<Repo> items, bool refresh) async {
            var data = await Git(context).getRepos(
                refresh: refresh,
                queryParameters: {
                  'page': page,
                  'page_size': 20
                }
                );
            items.addAll(data);
            // 如果接口返回的数量等于'page_size'，则认为还有数据，反之则认为最后一页
            return data.length == 20;
          },
          itemBuilder: (List list, int index, BuildContext context){
            return RepoItem(list[index]);
          }
      );
    }
  }
}

class MyDrawer extends StatelessWidget{
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //移除顶部padding
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            Expanded(child: _buildMenus(),)
          ],
        )
      ),
    );
  }

  Widget _buildHeader(){
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel value, Widget child){
        return GestureDetector(
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ClipOval(
                    child: value.isLogin ?
                      gmAvatar(value.user.avatar_url, width: 80) :
                      Image.asset("images/avatar-default.png", width: 80,),
                  ),
                ),
                Text(
                  value.isLogin ? value.user.login : GmLocalizations.of(context).login,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),

              ],
            ),
          ),
          onTap: (){
            if(!value.isLogin) Navigator.of(context).pushNamed("login");
          },
        );
      },
    );
  }

  Widget _buildMenus(){
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel value, Widget child){
        var gm = GmLocalizations.of(context);
        return ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(gm.theme),
              onTap: () => Navigator.of(context).pushNamed("themes"),
            ),

            ListTile(
              leading: const Icon(Icons.language),
              title: Text(gm.language),
              onTap: () => Navigator.of(context).pushNamed("language"),
            ),

            if(value.isLogin) ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: Text(gm.logout),
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context){
                    //退出账号前先弹二次确认窗
                    return AlertDialog(
                      content: Text(gm.logoutTip),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(gm.cancel),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text(gm.yes),
                          onPressed: (){
                            value.user = null;
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                );
              },
            )
          ],
        );
      },
    );
  }
}