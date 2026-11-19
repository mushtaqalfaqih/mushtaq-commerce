class Product {
  final String id;
  final String title;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewsCount;
  final String imagePath;
  final String category;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewsCount,
    required this.imagePath,
    required this.category,
    required this.description,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }
}
