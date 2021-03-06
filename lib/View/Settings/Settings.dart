import 'package:flutter/material.dart';
import 'package:glutassistant/Common/Constant.dart';
import 'package:glutassistant/Model/GlobalData.dart';
import 'package:glutassistant/Model/Settings/PasswordData.dart';
import 'package:glutassistant/Widget/SnackBar.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<PasswordData>(
        create: (BuildContext context) => PasswordData(),
      )
    ], child: _buildSettingsList());
  }

  Widget _buildBackgroundImage() {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => Container(
            color: Colors.white.withOpacity(globalData.opacity),
            child: ListTile(
              title: Text('启用背景图'),
              trailing: Switch(
                value: globalData.backgroundEnable == BackgroundImage.enable,
                onChanged: (value) {
                  globalData.setBackgroundEnable(value);
                },
              ),
              onTap: () => globalData.setBackgroundEnable(
                  !(globalData.backgroundEnable == BackgroundImage.enable)),
            )));
  }

  Widget _buildCurrentWeek() {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => Container(
            color: Colors.white.withOpacity(globalData.opacity),
            child: ListTile(
                title: Text('当前周'),
                subtitle: Text(globalData.currentWeekStr),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) => AlertDialog(
                            title: Text('当前周修改'),
                            content: TextField(
                              decoration: InputDecoration(labelText: '当前是第几周'),
                              controller: globalData.currentWeekController,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('确定'),
                                onPressed: () {
                                  globalData.setCurrentWeek();
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ));
                })));
  }

  Widget _buildDashboardDisplayType() {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => Container(
            color: Colors.white.withOpacity(globalData.opacity),
            child: ListTile(
              title: Text('一览课程显示方式'),
              subtitle: Text(
                  '${globalData.dashboardType == DashboardType.card ? '卡片' : '时间轴'}模式'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return Dialog(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text('卡片'),
                            onTap: () {
                              globalData.setDashboardType(0);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('时间轴'),
                            onTap: () {
                              globalData.setDashboardType(1);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
                    });
              },
            )));
  }

  Widget _buildCampusType() {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => Container(
            color: Colors.white.withOpacity(globalData.opacity),
            child: ListTile(
              title: Text('校区(雁山/屏风)'),
              subtitle: Text(
                  '${globalData.campusType == CampusType.yanshan ? '雁山' : '屏风'}'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return Dialog(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text('雁山'),
                            onTap: () {
                              globalData.setCampusType(0);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('屏风'),
                            onTap: () {
                              globalData.setCampusType(1);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
                    });
              },
            )));
  }

  Widget _buildColorListItem(BuildContext context, int index) {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => ListTile(
            leading: Icon(
              Icons.lens,
              color: Constant.LIST_THEME_COLOR[index][1],
            ),
            title: Text(Constant.LIST_THEME_COLOR[index][0]),
            dense: true,
            onTap: () {
              globalData.setThemeColorIndex(index);
              Navigator.pop(context);
            }));
  }

  Widget _buildOpacitySetting() {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => Container(
            color: Colors.white.withOpacity(globalData.opacity),
            child: ListTile(
                title: Text('控件透明度(仅在背景图启用时生效)'),
                subtitle: Text(globalData.opacity.toString()),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: Text('透明度修改'),
                          content: TextField(
                            decoration:
                                InputDecoration(labelText: '透明度(0.0-1.0)'),
                            controller: globalData.opacityController,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('确定'),
                              onPressed: () {
                                globalData.setOpacity();
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                })));
  }

  Widget _buildPickImage() {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => Container(
            color: Colors.white.withOpacity(globalData.opacity),
            child: ListTile(
              title: Text('选择背景图'),
              enabled: globalData.backgroundEnable == BackgroundImage.enable,
              onTap: () async {
                await globalData.saveImage();
                CommonSnackBar.buildSnackBar(context, globalData.msg);
              },
            )));
  }

  Widget _buildPasswordEditList() {
    return Consumer<PasswordData>(
        builder: (context, passwordData, _) => Column(children: <Widget>[
              for (int i = 0; i < Constant.LIST_LOGIN_TITLE.length; i++)
                if (i != 2) // 排除南宁分校的 教务密码都是同一个
                  _buildPasswordEdit(
                      Constant.LIST_LOGIN_TITLE[i][0],
                      passwordData.passwordEditController[i],
                      (pwd) => passwordData.setPassword(pwd, i))
            ]));
  }

  Widget _buildPasswordEdit(String title, TextEditingController controller,
      Function callback(password)) {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => Container(
              color: Colors.white.withOpacity(globalData.opacity),
              child: ListTile(
                  title: Text(title + '密码'),
                  subtitle: Text('密码就不告诉你啦'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: Text(title + '密码修改'),
                            content: TextField(
                              decoration:
                                  InputDecoration(labelText: title + '密码'),
                              obscureText: true,
                              controller: controller,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('确定'),
                                onPressed: () {
                                  callback(controller.text.trim());
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }),
            ));
  }

  Widget _buildSettingsList() {
    return ListView(
      children: <Widget>[
        _buildStudentId(),
        _buildPasswordEditList(),
        _buildCurrentWeek(),
        _buildCampusType(),
        _buildDashboardDisplayType(),
        _buildBackgroundImage(),
        _buildPickImage(),
        _buildThemeSetting(),
        _buildOpacitySetting()
      ],
    );
  }

  Widget _buildStudentId() {
    return Consumer2<PasswordData, GlobalData>(
        builder: (context, passwordData, globalData, _) {
      return Container(
          color: Colors.white.withOpacity(globalData.opacity),
          child: ListTile(
              title: Text('学号'),
              subtitle: Text(passwordData.studentId),
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: Text('学号修改'),
                      content: TextField(
                        decoration: InputDecoration(labelText: "学号"),
                        controller: passwordData.studentIdController,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('确定'),
                          onPressed: () {
                            passwordData.setStudentId();
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  })));
    });
  }

  Widget _buildThemeSetting() {
    return Consumer<GlobalData>(
        builder: (context, globalData, _) => Container(
            color: Colors.white.withOpacity(globalData.opacity),
            child: ListTile(
              title: Text('选择主题样式'),
              subtitle: Text('主题样式背景图是白色，与背景图冲突'),
              enabled: !(globalData.backgroundEnable == BackgroundImage.enable),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return Dialog(
                        child: Container(
                          height: 500,
                          width: 100,
                          child: ListView.builder(
                            itemCount: Constant.LIST_THEME_COLOR.length,
                            itemBuilder: (context, index) =>
                                _buildColorListItem(context, index),
                          ),
                        ),
                      );
                    });
              },
            )));
  }
}
