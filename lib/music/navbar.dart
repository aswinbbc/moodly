import '/emo/mood.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({Key? key, required this.clickFunction})
      : super(key: key);
  final Function() clickFunction;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: clickFunction,
            child: NavBarItem(
              icon: Icons.camera,
            ),
          ),
          Text(
            'Moodly',
            style: TextStyle(
                fontSize: 20,
                color: darkPrimaryColor,
                fontWeight: FontWeight.w500),
          ),
          // NavBarItem(
          //   icon: Icons.camera,
          // )
          SizedBox(
            width: 25,
          )
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;

  const NavBarItem({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: darkPrimaryColor.withOpacity(0.5),
            offset: Offset(5, 10),
            spreadRadius: 3,
            blurRadius: 10),
        BoxShadow(
            color: Colors.white,
            offset: Offset(-3, -4),
            spreadRadius: -2,
            blurRadius: 20)
      ], color: primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Icon(
        icon,
        color: darkPrimaryColor,
      ),
    );
  }
}
