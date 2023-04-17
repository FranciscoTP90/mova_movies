import 'package:flutter/material.dart';

import '../../../core/core.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
      {super.key,
      required this.icon,
      this.onTap,
      this.color = Colors.grey,
      this.activeColor = ColorsApp.primary,
      this.isActive = false,
      this.isNotified = false,
      required this.page,
      required this.title});
  final IconData icon;
  final Color color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final GestureTapCallback? onTap;
  final String title;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? activeColor : color,
                size: 26,
              ),
              const SizedBox(height: 3.0),
              Text(
                title,
                style: TextStyle(
                    fontSize: 14, color: isActive ? activeColor : color),
              )
            ],
          )),
    );
  }
}
