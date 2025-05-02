import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late Future<List<Product>> _products;

  @override
  void initState() {
    _products = ApiService().getProducts();
    super.initState();
  }

  void _refresh() {
    setState(() {
      _products = ApiService().getProducts();
    });
  }

  void _delete(String id) async {
    await ApiService().deleteProduct(id);
    _refresh();
  }

  void _navigateToAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()))
        .then((_) => _refresh());
  }

  void _navigateToEdit(Product product) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => EditProductScreen(product: product)))
        .then((_) => _refresh());
  }

  void _navigateToDetail(Product product) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🛒 Product List", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found."));
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(p.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("₹${p.price}", style: const TextStyle(color: Colors.green, fontSize: 14)),
                  onTap: () => _navigateToDetail(p),
                  trailing: PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'edit') _navigateToEdit(p);
                      if (val == 'delete') _delete(p.id!);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
