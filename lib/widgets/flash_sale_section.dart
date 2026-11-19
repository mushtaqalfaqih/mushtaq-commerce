import 'dart:async';
import 'package:bazaary_app/models/product.dart';
import 'package:bazaary_app/screens/product_details_screen.dart';
import 'package:flutter/material.dart';

class FlashSaleSection extends StatefulWidget {
  final List<Product> deals;
  final Function(Product) onAddToCart;

  const FlashSaleSection({
    super.key,
    required this.deals,
    required this.onAddToCart,
  });

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> {
  late Duration _remainingTime;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    // مؤقت 6 ساعات و 45 دقيقة و 20 ثانية
    _remainingTime = const Duration(hours: 6, minutes: 45, seconds: 20);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
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
        // ترويسة عروض الفلاش والعداد التنازلي
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFFF7043)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 24),
                const SizedBox(width: 6),
                const Text(
                  'عروض الفلاش العاجلة',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                // مؤقت العد التنازلي
                Row(
                  children: [
                    _buildTimerBox(seconds),
                    const Text(' : ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    _buildTimerBox(minutes),
                    const Text(' : ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    _buildTimerBox(hours),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // قائمة كروت العروض السريعة الأفقية
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.deals.length,
            itemBuilder: (context, index) {
              final product = widget.deals[index];
              final soldPercentage = 0.65 + (index * 0.1);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(
                        product: product,
                        onAddToCart: () => widget.onAddToCart(product),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 145,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // الصورة مع نسبة الخصم
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAFAFA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                product.imagePath,
                                fit: BoxFit.contain,
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
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${product.discountPercentage}%',
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

                      // تفاصيل السعر وشريط البيع
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${product.price.toStringAsFixed(0)} ر.ي',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF673AB7),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // شريط كم تم بيعه
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: soldPercentage.clamp(0.0, 1.0),
                                backgroundColor: Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.deepOrange,
                                ),
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'تم بيع ${(soldPercentage * 100).toInt()}%',
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimerBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
