import 'package:flutter/material.dart';

class HomeBottomBar extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final ValueChanged<int>? onTap;

  const HomeBottomBar({
    super.key,
    this.currentIndex = 4,
    this.cartCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF673AB7),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        // 1. حسابي (أقصى اليسار)
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'حسابي',
        ),
        // 2. السلة مع عداد المشتريات
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text(
              cartCount.toString(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          label: 'السلة',
        ),
        // 3. العروض
        const BottomNavigationBarItem(
          icon: Icon(Icons.discount_outlined, color: Colors.amber),
          label: 'العروض',
        ),
        // 4. الفئات
        const BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          label: 'الفئات',
        ),
        // 5. الرئيسية (أقصى اليمين)
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
      ],
    );
  }
}
