import 'package:flutter/material.dart';
import 'package:pomodoro/src/pages/cronometro_page.dart';
import 'package:pomodoro/src/pages/theme.dart';


class MyApp extends StatelessWidget{
  
  @override
  Widget build(BuildContext context){
    return DarkLightTheme();
  }
}

class DarkLightTheme extends StatefulWidget {
  const DarkLightTheme({
    Key key,
  }) : super(key: key);

  @override
  _DarkLightThemeState createState() => _DarkLightThemeState();
}

class _DarkLightThemeState extends State<DarkLightTheme> {
  
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.red[800],
        dialogBackgroundColor: Colors.blueGrey[100],
      ),*/
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      home: Center(
        child: CronometroPage(),
      )
    );
  }
}