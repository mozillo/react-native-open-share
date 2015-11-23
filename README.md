# react-native-open-share
Integrate wechat,weibo,qq,alipay [share,payment,login] to your react native application.
### built from [OpenShare](https://github.com/100apps/openshare) 
## Screen Shot

<img src="https://raw.githubusercontent.com/mozillo/react-native-open-share/master/screenshot_1.png" width="276"/>
<img src="https://raw.githubusercontent.com/mozillo/react-native-open-share/master/screentshot_2.png" width="276"/>

##Installation
1.Run `npm install https://github.com/mozillo/react-native-open-share.git --save` in your project directory.

2.Select your project , and find your [ ProjectName ] directory , Select it and right click "New Group", and rename it to "OpenShare", right click "Add Files to 'App' ...", select all files under the ./node_modules/react-native-open-share/src/ directory , and added them to OpenShare group.

3.Edit Info.plist, Open As => Source code, append ***new Info.plist code*** content after 

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
```

new Info.plist code:
```
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleURLName</key>
      <string>RNShare</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <!--wechat-->
        <string>wxd930ea5d5a258f4f</string>
        <!--qq-->
        <string>tencent1103194207</string>
        <string>tencent1103194207.content</string>
        <string>QQ41C1685F</string>
        <!--weibo-->
        <string>wb402180334</string>
        <!--renren-->
        <string>renrenshare228525</string>
        <!--facebook-->
        <string>fb776442542471056</string>
        
      </array>
    </dict>
  </array>
```

4.Edit AppDelegate.m :
Add header file:
```
#import "OpenShareHeader.h"
```
Add these code to "(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions" :

```
[OpenShare connectQQWithAppId:@"1103194207"];
[OpenShare connectWeiboWithAppKey:@"402180334"];
[OpenShare connectWeixinWithAppId:@"wxd930ea5d5a258f4f"];
[OpenShare connectRenrenWithAppId:@"228525" AndAppKey:@"1dd8cba4215d4d4ab96a49d3058c1d7f"];
```

and add this method after "(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions" block:

```
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
  //第二步：添加回调
  if ([OpenShare handleOpenURL:url]) {
    return YES;
  }
  //这里可以写上其他OpenShare不支持的客户端的回调，比如支付宝等。
  return YES;
}
```

###Done.

## Usage

example: 

```
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  DeviceEventEmitter,
  AlertIOS,
} = React;

var openShare = require('react-native-open-share');

var App = React.createClass({

  _wechatLogin: function() {
    var _this = this;
    openShare.wechatLogin();

    if(!_this.wechatLogin) {
      _this.wechatLogin = DeviceEventEmitter.addListener(
        'managerCallback',
        (response) => {
          AlertIOS.alert(
            'response',
            JSON.stringify(response)
          );
          
          _this.wechatLogin.remove();
          delete _this.wechatLogin;
        }
      );
    }
  },

  render: function() {
    return (
      <View style={styles.container}>

        <TouchableOpacity onPress={this._wechatLogin}>
          <Text>WeChat Login</Text>
        </TouchableOpacity>

        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('App', () => App);

```
## current API

```
openShare.qqLogin();
openShare.wechatLogin();
openShare.weiboLogin();
```

##Other
```

wechat access token request: 
https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code

wechat user profile request:
https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID

