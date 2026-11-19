import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;

  const HomeHeader({
    super.key,
    this.onSearchChanged,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Stack(
        children: [
          // الخلفية مع التدرج اللوني والانحناء السفلي
          Container(
            height: 205,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 41, 153, 205),
                  Color.fromARGB(255, 209, 160, 180),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // الصف الأول: الموقع والعنوان
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: const [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 4, height: 40),
                        Text(
                          'توصيل إلى: صنعاء الامانة ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          'ضع عنوانك هنا',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 1.5,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // الصف الثاني: كروت بازاري مول وسوبرماركت
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/bazzarry_mall.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/bazzarry_mall2.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // حقل البحث يثبت في أسفل الـ Header ليغطي حافة المنحنى
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'ابحث الان في منتجات سوق بازاري...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF673AB7),
                    fontSize: 13,
                  ),
                  suffixIcon: const Icon(Icons.search, color: Color(0xFF673AB7)),
                  prefixIcon: (searchController != null &&
                          searchController!.text.isNotEmpty)
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: () {
                            searchController!.clear();
                            if (onSearchChanged != null) onSearchChanged!('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
