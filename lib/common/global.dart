import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_client_demo/models/index.dart';
import 'package:github_client_demo/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache_object.dart';
import 'git.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red
];

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  static NetCache netCache = NetCache();

  static List<MaterialColor> get themes => _themes;

  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在APP启动时执行
  static Future init() async{
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if(_profile != null){
      try{
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch(e){
        print(e);
      }
    }

    // 如果没有缓存策略，设置默认缓存策略
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    //初始化网络请求相关配置
    Git.init();
  }

  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));
}