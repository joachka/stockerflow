class Product {
  final String id;
  final String name;
  final String? category;
  final String? unitType;
  final String? barcode;

  Product({
    required this.id,
    required this.name,
    this.category,
    this.unitType,
    this.barcode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      unitType: json['unit_type'],
      barcode: json['barcode'],
    );
  }
}
