import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {
      'title': 'موبايل وأجهزة ذكية',
      'icon': Icons.phone_android,
      'color': Color(0xFF673AB7),
      'count': '150+ منتج',
    },
    {
      'title': 'التلفاز وملحقاته',
      'icon': Icons.tv,
      'color': Color(0xFF00897B),
      'count': '85+ منتج',
    },
    {
      'title': 'أجهزة المنزل والمطبخ',
      'icon': Icons.kitchen,
      'color': Color(0xFFE65100),
      'count': '220+ منتج',
    },
    {
      'title': 'باكجات التوفير',
      'icon': Icons.card_giftcard,
      'color': Color(0xFFC2185B),
      'count': '45+ عرض',
    },
    {
      'title': 'أزياء وملبوسات',
      'icon': Icons.checkroom,
      'color': Color(0xFF3949AB),
      'count': '340+ منتج',
    },
    {
      'title': 'عطور وعناية شخصية',
      'icon': Icons.spa,
      'color': Color(0xFF8E24AA),
      'count': '190+ منتج',
    },
    {
      'title': 'سوبرماركت وبقالة',
      'icon': Icons.local_grocery_store,
      'color': Color(0xFF2E7D32),
      'count': '500+ منتج',
    },
    {
      'title': 'ألعاب وأطفال',
      'icon': Icons.toys,
      'color': Color(0xFFF57F17),
      'count': '110+ منتج',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'جميع الفئات والأقسام',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.15,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم اختيار فئة: ${cat['title']}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (cat['color'] as Color).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: cat['color'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cat['title'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat['count'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
