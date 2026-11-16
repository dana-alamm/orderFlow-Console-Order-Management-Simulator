

import 'package:collection/collection.dart'; 
import '../models/product.dart';
import '../models/order.dart';
import '../utils/formatting.dart'; 

class OutOfStockException implements Exception {
  final String message;
  OutOfStockException(this.message);
  @override
  String toString() => 'OutOfStockException: $message';
}

mixin Discountable {
  double calculateFinalTotal(double subtotal, bool hasPhysicalItem, {double taxRate = 0.10, String? couponCode}) {
    double discounted = subtotal;
    if (couponCode == 'SAVE10') {
      discounted = subtotal * 0.90; 
    }
  
    double tax = discounted * taxRate;
    double shipping = hasPhysicalItem ? 5.0 : 0.0;
    
    return discounted + tax + shipping;
  }
}

class OrderService with Discountable {
  final List<Product> catalog;
  final ReceiptPrinter printer;

  OrderService({
    required this.catalog,
    required this.printer,
  });

  void printCatalog() {
    print('\n--- Store Catalog ---');
    for (var product in catalog) {
      print('- ${product.name} (SKU: ${product.sku}) - \$${product.price}');
    }
    print('---------------------\n');
  }

  Map<String, int> getInventoryCounts() {
    Map<String, int> counts = {};
    for (var product in catalog) {
      if (product is PhysicalProduct) {
        counts[product.name] = product.stock;
      }
    }
    return counts;
  }

  void placeOrder(String orderId, Map<String, int> requestedItems, {String? couponCode}) {
    bool isValid = orderId.isNotEmpty && orderId.startsWith('ORD');
    
    if (!isValid) {
      print(' Validation Error: Invalid Order ID Format ($orderId).');
      return;
    }

    Order currentOrder = Order(orderId: orderId);
    bool hasPhysicalItem = false; 

    print('--- Processing Request for Order: $orderId ---');

    requestedItems.forEach((sku, quantity) {
    
      if (quantity <= 0) {
        print(' Error: Quantity for "$sku" must be greater than 0. Request rejected.');
        return;
      }

      Product? product = catalog.firstWhereOrNull((p) => p.sku == sku);

      if (product == null) {
        print(' Error: Product with SKU "$sku" is unknown. Request rejected.');
        return; 
      }

      if (product is PhysicalProduct) {
        hasPhysicalItem = true; 
        if (product.stock < quantity) {
          throw OutOfStockException('Requested $quantity of "${product.name}", but only ${product.stock} available.');
        }
        product.stock -= quantity;
      }

      for (int i = 0; i < quantity; i++) {
        currentOrder.addProduct(product);
      }
      print(' Successfully added $quantity x ${product.name} to order.');
    });

    if (currentOrder.items.isEmpty) {
      print(' Order $orderId is empty after validation. No receipt generated.\n');
      return;
    }

    currentOrder.fulfillOrder(); 
    currentOrder.printOrderStatus(); 

    double subtotal = currentOrder.calculateSubtotal();
    
    double total = calculateFinalTotal(
      subtotal, 
      hasPhysicalItem, 
      taxRate: 0.10, 
      couponCode: couponCode
    );

  
    String receiptText = 'Order ID: ${currentOrder.orderId}\n';
    receiptText += 'Items:\n';
    for (var item in currentOrder.items) {
      receiptText += '- ${item.name} (\$${item.price.toStringAsFixed(2)})\n';
    }
    
    double discountedSubtotal = couponCode == 'SAVE10' ? subtotal * 0.90 : subtotal;
    double tax = discountedSubtotal * 0.10;
    
    receiptText += 'Subtotal: \$${subtotal.toStringAsFixed(2)}\n';
    if (couponCode != null) {
      receiptText += 'Discount (10%): -\$${(subtotal * 0.10).toStringAsFixed(2)}\n';
    }
    receiptText += 'Tax (10% after discount): \$${tax.toStringAsFixed(2)}\n';
    if (hasPhysicalItem) {
      receiptText += 'Shipping: \$5.00\n';
    }
    receiptText += 'Grand total: \$${total.toStringAsFixed(2)}\n';
    
    var p01 = catalog.firstWhereOrNull((p) => p.sku == 'P01');
    if (p01 is PhysicalProduct) {
      receiptText += 'Remaining P01 stock: ${p01.stock}';
    }

    printer.printReceipt(receiptText);
  }

  Stream<OrderStatus> trackOrder(Order order) async* {
    yield OrderStatus.pending;
    await Future.delayed(Duration(milliseconds: 300));
    yield OrderStatus.paid;
    await Future.delayed(Duration(milliseconds: 300));
    yield OrderStatus.completed;
  }
}