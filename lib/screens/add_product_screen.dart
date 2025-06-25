import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductScreen extends StatefulWidget {
  final String storeId;

  const AddProductScreen({super.key, required this.storeId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _unitTypeController = TextEditingController(text: 'pcs');
  final _barcodeController = TextEditingController();

  final supabase = Supabase.instance.client;

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final unitType = _unitTypeController.text.trim();
    final barcode = _barcodeController.text.trim();

    try {
      await supabase.from('products').insert({
        'store_id': widget.storeId,
        'name': name,
        'category': category.isNotEmpty ? category : null,
        'unit_type': unitType.isNotEmpty ? unitType : 'pcs',
        'barcode': barcode.isNotEmpty ? barcode : null,
      });

      if (context.mounted) {
        Navigator.pop(context, true); // return success
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _unitTypeController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _unitTypeController,
                decoration:
                    const InputDecoration(labelText: 'Unit type (e.g. pcs, kg)'),
              ),
              TextFormField(
                controller: _barcodeController,
                decoration:
                    const InputDecoration(labelText: 'Barcode (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addProduct,
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
