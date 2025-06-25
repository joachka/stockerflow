import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddInventoryScreen extends StatefulWidget {
  final String productId;
  final String productName;

  const AddInventoryScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  DateTime? _selectedDate;

  final supabase = Supabase.instance.client;

  Future<void> addInventory() async {
    if (!_formKey.currentState!.validate()) return;

    final quantity = double.tryParse(_quantityController.text.trim());

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid quantity')),
      );
      return;
    }

    try {
      await supabase.from('inventory_batches').insert({
        'product_id': widget.productId,
        'quantity': quantity,
        'best_before':
            _selectedDate != null ? _selectedDate!.toIso8601String() : null,
      });

      if (context.mounted) {
        Navigator.pop(context, true); // signal success
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Stock: ${widget.productName}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_selectedDate == null
                        ? 'Pick best-before date (optional)'
                        : 'Best-before: ${_selectedDate!.toLocal()}'
                            .split(' ')[0]),
                  ),
                  if (_selectedDate != null)
                    IconButton(
                      onPressed: () {
                        setState(() => _selectedDate = null);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: addInventory,
                child: const Text('Add to Inventory'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
