import 'dart:async';
import 'package:bazaary_app/models/product.dart';
import 'package:bazaary_app/screens/product_details_screen.dart';
import 'package:flutter/material.dart';

class FlashSaleSection extends StatefulWidget {
  final List<Product> deals;
  final Function(Product) onAddToCart;
  final Set<String>? favoriteIds;
  final Function(Product)? onToggleFavorite;

  const FlashSaleSection({
    super.key,
    required this.deals,
    required this.onAddToCart,
    this.favoriteIds,
    this.onToggleFavorite,
  });

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> {
  late Duration _remainingTime;
  Timer? _countdownTimer;
  bool _colonVisible = true;

  @override
  void initState() {
    super.initState();
    // مؤقت 5 ساعات و 24 دقيقة و 18 ثانية كما هو مطلوب
    _remainingTime = const Duration(hours: 5, minutes: 24, seconds: 18);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _colonVisible = !_colonVisible;
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          _remainingTime = const Duration(hours: 12);
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatTwoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = _formatTwoDigits(_remainingTime.inHours);
    final minutes = _formatTwoDigits(_remainingTime.inMinutes.remainder(60));
    final seconds = _formatTwoDigits(_remainingTime.inSeconds.remainder(60));

    return Column(
      children: [
        // شريط أحمر متدرج جذاب بعنوان: "عروض تنتهي خلال:"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color(0xFFD32F2F), // أحمر داكن فخم
                  Color(0xFFFF3D00), // أحمر برتقالي مشرق
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD32F2F).withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: Colors.amberAccent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'عروض تنتهي خلال:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                // مؤقت العداد الرقمي الحي بنمط أمازون ونون [ 05 : 24 : 18 ]
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      _buildDigitalBox(hours, 'ساعة'),
                      _buildDigitalSeparator(),
                      _buildDigitalBox(minutes, 'دقيقة'),
                      _buildDigitalSeparator(),
                      _buildDigitalBox(seconds, 'ثانية', isPulsing: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // قائمة كروت العروض السريعة مع حركات اللمس والـ Hero
        SizedBox(
          height: 225,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.deals.length,
            itemBuilder: (context, index) {
              final product = widget.deals[index];
              final soldPercentage = 0.65 + (index * 0.1);
              final heroTag = 'flash_deal_${product.id}';

              return _FlashDealCard(
                product: product,
                heroTag: heroTag,
                soldPercentage: soldPercentage,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(
                        product: product,
                        onAddToCart: () => widget.onAddToCart(product),
                        heroTag: heroTag,
                        isFavorite:
                            widget.favoriteIds?.contains(product.id) ?? false,
                        onToggleFavorite: () =>
                            widget.onToggleFavorite?.call(product),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDigitalBox(String value, String label, {bool isPulsing = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPulsing
              ? Colors.amber.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: isPulsing ? Colors.amberAccent : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          fontFamily: 'monospace',
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildDigitalSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _colonVisible ? 1.0 : 0.3,
        child: const Text(
          ':',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _FlashDealCard extends StatefulWidget {
  final Product product;
  final String heroTag;
  final double soldPercentage;
  final VoidCallback onTap;

  const _FlashDealCard({
    required this.product,
    required this.heroTag,
    required this.soldPercentage,
    required this.onTap,
  });

  @override
  State<_FlashDealCard> createState() => _FlashDealCardState();
}

class _FlashDealCardState extends State<_FlashDealCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: Container(
          width: 150,
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isPressed ? 0.02 : 0.06),
                blurRadius: _isPressed ? 3 : 8,
                offset: Offset(0, _isPressed ? 1 : 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة العرض مع Hero Animation وشارة الخصم
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Hero(
                        tag: widget.heroTag,
                        child: Image.asset(
                          widget.product.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${widget.product.discountPercentage}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // السعر وشريط البيع
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.product.price.toStringAsFixed(0)} ر.ي',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF673AB7),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // شريط نسبة البيع
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: widget.soldPercentage.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF3D00),
                        ),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'تم بيع ${(widget.soldPercentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
