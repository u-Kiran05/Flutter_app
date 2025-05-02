import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(product.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text("Price: ₹${product.price}", style: const TextStyle(fontSize: 18, color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
