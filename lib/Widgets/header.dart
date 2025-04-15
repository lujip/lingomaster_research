import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {

  const CustomHeader({super.key});
  @override
  Widget build(BuildContext context) {
     var appState = context.watch<MyAppState>();
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 92, 112, 122),
      elevation: 0,
      title: Text(
        "LINGOMASTER",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Open the sidebar
          },
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(appState.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          onPressed: () {
            appState.toggleTheme();
             },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

