import 'package:flutter/material.dart';
import 'package:my_app/Widgets/footer.dart';
import 'package:my_app/Widgets/header.dart';
import 'package:my_app/Widgets/sidebar.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onTabTapped;

  const BaseLayout({
    required this.child,
    required this.currentIndex,
    required this.onTabTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(),
          Expanded(child: child),
          CustomFooter(
            currentIndex: currentIndex,
            onTabTapped: onTabTapped,
          ),
        ],
      ),
    );
  }
}

