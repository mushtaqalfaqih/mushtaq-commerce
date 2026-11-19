import 'package:bazaary_app/bottom_bar.dart';
import 'package:bazaary_app/data/mock_data.dart';
import 'package:bazaary_app/home_header.dart';
import 'package:bazaary_app/models/cart_item.dart';
import 'package:bazaary_app/models/product.dart';
import 'package:bazaary_app/screens/cart_screen.dart';
import 'package:bazaary_app/screens/categories_screen.dart';
import 'package:bazaary_app/screens/offers_screen.dart';
import 'package:bazaary_app/screens/profile_screen.dart';
import 'package:bazaary_app/widgets/product_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بازاري',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF673AB7),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 4; // الافتراضي: الرئيسية (أقصى اليمين)
  final List<CartItem> _cartItems = [];

  void _addToCart(Product product) {
    setState(() {
      final index =
          _cartItems.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(CartItem(product: product));
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة "${product.title}" إلى السلة'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF673AB7),
        action: SnackBarAction(
          label: 'عرض السلة',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
      ),
    );
  }

  void _incrementCartItem(CartItem item) {
    setState(() {
      item.quantity++;
    });
  }

  void _decrementCartItem(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _cartItems.remove(item);
      }
    });
  }

  void _removeFromCart(CartItem item) {
    setState(() {
      _cartItems.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف المنتج من السلة'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  int get _totalCartCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildCurrentPage(),
      bottomNavigationBar: HomeBottomBar(
        currentIndex: _currentIndex,
        cartCount: _totalCartCount,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 4:
        return _buildHomeContent();
      case 3:
        return const CategoriesScreen();
      case 2:
        return const OffersScreen();
      case 1:
        return CartScreen(
          cartItems: _cartItems,
          onIncrement: _incrementCartItem,
          onDecrement: _decrementCartItem,
          onRemove: _removeFromCart,
          onStartShopping: () {
            setState(() {
              _currentIndex = 4;
            });
          },
        );
      case 0:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        const HomeHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),

                // البانر الإعلاني الأول
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'images/panar_main1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // عنوان تسوق حسب الفئة
                _buildSectionHeader('تسوق حسب الفئة', onSeeAll: () {
                  setState(() => _currentIndex = 3);
                }),

                const SizedBox(height: 14),

                // قائمة الفئات الأفقية
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // الصف الأول للفئات
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            _buildCategoryItem(
                              'اشتري بالتقسيط',
                              'images/cat_1.jpg',
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryItem(
                              'منتجات مختارة',
                              'images/cat_2.jpg',
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryItem(
                              'باكجات التوفير',
                              'images/cat_3.png',
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryItem(
                              'منتجات جديدة',
                              'images/cat_new.png',
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryItem(
                              'مشتاق',
                              'images/mo22.png',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // الصف الثاني للفئات
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            _buildCategoryItem(
                              'الإلكترونيات وأجهزة المنزل',
                              'images/Elctron_home_Tool.png',
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryItem(
                              'منتجات المؤثرين',
                              'images/mo2.png',
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryItem(
                              'التلفاز وملحقاته',
                              'images/talphaz.png',
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryItem(
                              'موبايل و أجهزة',
                              'images/phon.png',
                            ),
                            const SizedBox(width: 12),
                            _buildCategoryItem(
                              'مشتاق',
                              'images/mo22.png',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // البانر الإعلاني الثاني
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'images/panar_main2.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // بطاقات المؤثرين: مشتاق الفقية وحنان فازع جنباً إلى جنب
                _buildSectionHeader('مؤثرو سوق بازاري'),
                const SizedBox(height: 12),
                _buildDoubleBanner('images/catcot1.jpg', 'images/catcot.jpg'),

                const SizedBox(height: 28),

                // قسم المنتجات المقترحة والتخفيضات (شبكة المنتجات التفاعلية)
                _buildSectionHeader(
                  'أحدث المنتجات والعروض',
                  onSeeAll: () {
                    setState(() => _currentIndex = 2);
                  },
                ),
                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mockProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final product = mockProducts[index];
                      return ProductCard(
                        product: product,
                        onAddToCart: () => _addToCart(product),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF673AB7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A148C),
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text(
                'عرض الكل',
                style: TextStyle(
                  color: Color(0xFF673AB7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDoubleBanner(String leftImage, String rightImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                leftImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                rightImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imagePath) {
    return SizedBox(
      width: 75,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
