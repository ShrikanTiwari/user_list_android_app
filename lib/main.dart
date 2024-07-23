import 'package:flutter/material.dart';
import 'package:assingmet_test/screens/list_screen/user_list_screen.dart';
import 'package:assingmet_test/theme/theme.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: AppTheme.darkThemeMode, 
      home: UserListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
