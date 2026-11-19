import 'package:bazaary_app/bottom_bar.dart';
import 'package:bazaary_app/data/mock_data.dart';
import 'package:bazaary_app/home_header.dart';
import 'package:bazaary_app/models/cart_item.dart';
import 'package:bazaary_app/models/product.dart';
import 'package:bazaary_app/screens/cart_screen.dart';
import 'package:bazaary_app/screens/categories_screen.dart';
import 'package:bazaary_app/screens/offers_screen.dart';
import 'package:bazaary_app/screens/profile_screen.dart';
import 'package:bazaary_app/screens/wishlist_screen.dart';
import 'package:bazaary_app/widgets/add_to_cart_bottom_sheet.dart';
import 'package:bazaary_app/widgets/banner_carousel.dart';
import 'package:bazaary_app/widgets/flash_sale_section.dart';
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
      title: 'بازاري مشتاق',
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
  final Set<String> _favoriteIds = {'p1', 'p2'}; // عنصرين افتراضيين للمفضلة
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

    // إظهار النافذة المنزلقة السفلية المخصصة (Custom Bottom Sheet)
    showAddToCartBottomSheet(
      context: context,
      product: product,
      totalCartCount: _totalCartCount,
      totalCartPrice: _totalCartPrice,
      onGoToCart: () {
        setState(() {
          _currentIndex = 1;
        });
      },
    );
  }

  void _toggleFavorite(Product product) {
    final isFav = _favoriteIds.contains(product.id);
    setState(() {
      if (isFav) {
        _favoriteIds.remove(product.id);
      } else {
        _favoriteIds.add(product.id);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !isFav
              ? 'تمت إضافة "${product.title}" إلى المفضلة ❤️'
              : 'تمت إزالة "${product.title}" من المفضلة',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: !isFav ? Colors.redAccent : Colors.grey.shade800,
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

  double get _totalCartPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  List<Product> get _favoriteProducts =>
      mockProducts.where((p) => _favoriteIds.contains(p.id)).toList();

  String _normalizeArabic(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[أإآ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .trim();
  }

  List<Product> get _filteredProducts {
    if (_searchQuery.isEmpty) return mockProducts;
    final normalizedQuery = _normalizeArabic(_searchQuery);

    return mockProducts.where((p) {
      final title = _normalizeArabic(p.title);
      final cat = _normalizeArabic(p.category);
      final desc = _normalizeArabic(p.description);
      return title.contains(normalizedQuery) ||
          cat.contains(normalizedQuery) ||
          desc.contains(normalizedQuery);
    }).toList();
  }

  void _openWishlistScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WishlistScreen(
          favoriteProducts: _favoriteProducts,
          onToggleFavorite: _toggleFavorite,
          onAddToCart: _addToCart,
        ),
      ),
    );
  }

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
        return ProfileScreen(
          wishlistCount: _favoriteIds.length,
          onOpenWishlist: _openWishlistScreen,
        );
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        HomeHeader(
          searchController: _searchController,
          onSearchChanged: (val) {
            setState(() {
              _searchQuery = val.trim();
            });
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _searchQuery.isNotEmpty
                ? _buildSearchResults()
                : _buildFullHomeBody(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = _filteredProducts;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نتائج البحث عن: "$_searchQuery"',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A148C),
                ),
              ),
              Text(
                '(${results.length} منتج)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (results.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'لا توجد منتجات مطابقة للبحث',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'جرّب كتابة كلمة أخرى مثل "موبايل" أو "تلفزيون" أو "خلاط"',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final product = results[index];
                return ProductCard(
                  product: product,
                  isFavorite: _favoriteIds.contains(product.id),
                  onToggleFavorite: () => _toggleFavorite(product),
                  onAddToCart: () => _addToCart(product),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFullHomeBody() {
    return Column(
      children: [
        const SizedBox(height: 22),

        // 1. سلايدر البانرات المتحرك تلقائياً
        const BannerCarousel(
          bannerImages: [
            'images/panar_main1.jpg',
            'images/panar_main2.jpg',
          ],
        ),

        const SizedBox(height: 20),

        // 2. عنوان تسوق حسب الفئة + صفين أفقيين للفئات
        _buildSectionHeader('تسوق حسب الفئة', onSeeAll: () {
          setState(() => _currentIndex = 3);
        }),

        const SizedBox(height: 14),

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

        const SizedBox(height: 24),

        // 3. عروض الفلاش العاجلة مع عداد الوقت الحي
        FlashSaleSection(
          deals: mockProducts,
          favoriteIds: _favoriteIds,
          onToggleFavorite: _toggleFavorite,
          onAddToCart: _addToCart,
        ),

        const SizedBox(height: 24),

        // 4. بطاقات المؤثرين: مشتاق الفقية وحنان فازع جنباً إلى جنب
        _buildSectionHeader('مؤثرو سوق بازاري'),
        const SizedBox(height: 12),
        _buildDoubleBanner('images/catcot1.jpg', 'images/catcot.jpg'),

        const SizedBox(height: 28),

        // 5. قسم المنتجات المقترحة والتخفيضات (شبكة المنتجات)
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final product = mockProducts[index];
              return ProductCard(
                product: product,
                isFavorite: _favoriteIds.contains(product.id),
                onToggleFavorite: () => _toggleFavorite(product),
                onAddToCart: () => _addToCart(product),
              );
            },
          ),
        ),

        const SizedBox(height: 30),
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
