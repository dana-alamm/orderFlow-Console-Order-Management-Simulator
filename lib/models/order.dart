import 'package:orderflow/models/product.dart';

enum OrderStatus { pending, paid, completed, failed }

class Order {
  final String orderId;
  final DateTime date;
  final List<Product> items; //looks like a cart

  //String status;
  OrderStatus status;

  Order({required this.orderId})
    : date = DateTime.now(),
      items = [], //empty cart
      status = OrderStatus.pending;

  void addProduct(Product product) {
    items.add(product);
  }

  double calculateSubtotal() {
    double subtotal = 0.0;
    for (var item in items) {
      subtotal += item.price;
    }
    return subtotal;
  }

  void fulfillOrder([bool printLog = true]) {
    if (printLog) {
      print('--- Processing Order: $orderId ---');
    }
    for (var item in items) {
      item.fulfillment();
    }
    status = OrderStatus.completed;
  }//SOLID CODE 

  (double, int) orderSummary() {
    double total = calculateSubtotal();
    int totalQuantity = items.length;
    return (total, totalQuantity);
  }//i used record to return two values at the same time 

  void printOrderStatus() {
    var (total, qty) = orderSummary();

    switch ((status, total)) {
      case (OrderStatus.paid, >= 100):
        print('Message: Order $orderId is VIP (paid & over\$100).');
      case (OrderStatus.completed, _):// this is WildCard to skip the value
        print('Message: Order $orderId has been successfully fulfilled.');
      case (OrderStatus.pending, _):
        print('Message: Order $orderId is waiting to be processed.');
      case (OrderStatus.failed, _):
        print('Message: Order $orderId has failed.');
    }
  }
}
