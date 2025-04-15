import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
            ),
            child: Text(
              'Details',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text('This Application is a research performed by CIT, Computer science students. If you have reports or problems with the application, email: jepijul@gmail.com. \n\nThank you <3'),
            onTap: () {},
          ),
         /* ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {},
          ), */
        ],
      ),
    );
  }
}
