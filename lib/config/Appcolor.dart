import 'package:flutter/material.dart';

class AppSkin {
  final Color sidebar;
  final Color backgroundStart;
  final Color backgroundEnd;
  final Color border;
  final Color buttonMouseOver;
  final Color buttonMouseDown;
  final Color icon;
  final Color iconMouseOver;
  final Color iconMouseDown;

  const AppSkin(
      {required this.sidebar,
      required this.backgroundStart,
      required this.backgroundEnd,
      required this.border,
      required this.buttonMouseOver,
      required this.buttonMouseDown,
      required this.icon,
      required this.iconMouseOver,
      required this.iconMouseDown});
}

AppSkin yellowSkin = const AppSkin(
  sidebar: Color(0xFFF6A00C),
  backgroundStart: Color(0xFFFFD500),
  backgroundEnd: Color(0xFFF6A00C),
  border: Color(0xFF805306),
  buttonMouseOver: Color(0xFFF6A00C),
  buttonMouseDown: Color(0xFF805306),
  icon: Color(0xFF805306),
  iconMouseOver: Color(0xFF805306),
  iconMouseDown: Color(0xFFFFD500),
);

AppSkin greenSkin = const AppSkin(
    sidebar: Color(0xFF198A00),
    backgroundStart: Color(0xFF25C901),
    backgroundEnd: Color(0xFF198A00),
    border: Color(0xFF0C4500),
    buttonMouseOver: Color(0xFF198A00),
    buttonMouseDown: Color(0xFF0C4500),
    icon: Color(0xFF0C4500),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFFFFFFF));

AppSkin blueSkin = const AppSkin(
    sidebar: Color(0xFF125CDB),
    backgroundStart: Color(0xFF079BF2),
    backgroundEnd: Color(0xFF125CDB),
    border: Color(0xFF092E6E),
    buttonMouseOver: Color(0xFF125CDB),
    buttonMouseDown: Color(0xFF092E6E),
    icon: Color(0xFFFFFFFF),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFFFFFFF));

AppSkin purpleSkin = const AppSkin(
    sidebar: Color(0xFF8700B2),
    backgroundStart: Color(0xFFCC00C5),
    backgroundEnd: Color(0xFF9A00CC),
    border: Color(0xFF730099),
    buttonMouseOver: Color(0xFF9A00CC),
    buttonMouseDown: Color(0xFF730099),
    icon: Color(0xFFFFFFFF),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFFFFFFF));

AppSkin cherrySkin = const AppSkin(
    sidebar: Color(0xFF850250),
    backgroundStart: Color(0xFFC90078),
    backgroundEnd: Color(0xFF850250),
    border: Color(0xFF700043),
    buttonMouseOver: Color(0xFF850250),
    buttonMouseDown: Color(0xFF700043),
    icon: Color(0xFFFFFFFF),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFFFFFFF));

final skins = [yellowSkin, greenSkin, blueSkin, purpleSkin, cherrySkin];

class AppColors extends InheritedWidget {
  final AppSkin colors;
  //final Widget child;
  const AppColors({
    Key? key,
    required this.colors,
    required Widget child,
  }) : super(key: key, child: child);

  static AppColors? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppColors>();
  }

  @override
  bool updateShouldNotify(AppColors oldWidget) => colors != oldWidget.colors;
}
