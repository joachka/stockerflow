import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/store.dart';

class StoreSelectorScreen extends StatefulWidget {
  const StoreSelectorScreen({super.key});

  @override
  State<StoreSelectorScreen> createState() => _StoreSelectorScreenState();
}

class _StoreSelectorScreenState extends State<StoreSelectorScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<Store>> futureStores;

  Future<List<Store>> fetchStores() async {
    final List<dynamic> data = await supabase
        .from('stores')
        .select('id, name')
        .order('name');

    return data.map((item) => Store.fromJson(item)).toList();
  }

  @override
  void initState() {
    super.initState();
    futureStores = fetchStores();
  }

  void enterStore(Store store) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: ${store.name}')),
    );
    // TODO: Store this in state/context and navigate to inventory
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Store')),
      body: FutureBuilder<List<Store>>(
        future: futureStores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stores = snapshot.data!;
          if (stores.isEmpty) {
            return const Center(child: Text('No stores found'));
          }

          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return ListTile(
                title: Text(store.name),
                onTap: () => enterStore(store),
              );
            },
          );
        },
      ),
    );
  }
}
