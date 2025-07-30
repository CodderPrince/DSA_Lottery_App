import 'package:flutter/material.dart';

PreferredSizeWidget MyAppBar18() {
  return AppBar(
    elevation: 8,
    backgroundColor: Colors.transparent,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
    ),
    // leading: IconButton(
    //   icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
    //   onPressed: () {
    //     // Add your back navigation logic here
    //   },
    // ),
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const Icon(Icons.location_on, color: Colors.white, size: 28),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [Colors.yellow, Colors.white, Colors.yellow,],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: const Text(
            "Project Assignment Lottery",
            style: TextStyle(
              color: Colors.white, // Still needed for ShaderMask
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    centerTitle: true,
    // actions: [
    //   // 🔍 Search
    //   // IconButton(
    //   //   icon: const Icon(Icons.search, color: Colors.white),
    //   //   onPressed: () {
    //   //     // Search functionality
    //   //   },
    //   // ),
    //
    //   // 🔔 Notifications with Badge
    //   // Stack(
    //   //   children: [
    //   //     IconButton(
    //   //       icon: const Icon(Icons.notifications, color: Colors.white),
    //   //       onPressed: () {
    //   //         // Notification logic
    //   //       },
    //   //     ),
    //   //     Positioned(
    //   //       right: 8,
    //   //       top: 8,
    //   //       child: Container(
    //   //         padding: const EdgeInsets.all(2),
    //   //         decoration: BoxDecoration(
    //   //           color: Colors.red,
    //   //           borderRadius: BorderRadius.circular(10),
    //   //         ),
    //   //         constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
    //   //         child: const Text(
    //   //           '3', // Example badge count
    //   //           style: TextStyle(color: Colors.white, fontSize: 10),
    //   //           textAlign: TextAlign.center,
    //   //         ),
    //   //       ),
    //   //     ),
    //   //   ],
    //   // ),
    //
    //   // 👤 Profile Icon (Original Feature)
    //   const IconButton(
    //     onPressed: null,
    //     icon: Icon(Icons.account_circle_rounded, size: 35, color: Colors.white),
    //   ),
    //
    //   // ⋮ Popup Menu
    //   PopupMenuButton<String>(
    //     icon: const Icon(Icons.more_vert, color: Colors.white),
    //     onSelected: (value) {
    //       if (value == 'settings') {
    //         // Go to settings
    //       } else if (value == 'logout') {
    //         // Logout logic
    //       }
    //     },
    //     itemBuilder:
    //         (context) => const [
    //           PopupMenuItem(value: 'settings', child: Text('Settings')),
    //           PopupMenuItem(value: 'logout', child: Text('Logout')),
    //         ],
    //   ),
    // ],
  );
}
