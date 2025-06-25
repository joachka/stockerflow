import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import 'add_product_screen.dart';
import 'add_inventory_screen.dart'; // ✅ Add this import

class ProductListScreen extends StatefulWidget {
  final String storeId;

  const ProductListScreen({super.key, required this.storeId});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<Product>> futureProducts;

  Future<List<Product>> fetchProducts() async {
    final List data = await supabase
        .from('products')
        .select()
        .eq('store_id', widget.storeId)
        .order('name');

    return data.map((e) => Product.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Products')),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(child: Text('No products yet'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                title: Text(p.name),
                subtitle: Text(p.unitType ?? 'unit'),
                onTap: () async {
                  final added = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddInventoryScreen(
                        productId: p.id,
                        productName: p.name,
                      ),
                    ),
                  );
                  if (added == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inventory added')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddProductScreen(storeId: widget.storeId),
            ),
          );

          if (added == true) {
            setState(() {
              futureProducts = fetchProducts();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
