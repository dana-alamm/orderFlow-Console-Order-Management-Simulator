import 'package:orderflow/models/order.dart';

class PaymentService {
  Future<bool>processPayment(Order order)async{
    print('Initiating payment for Order:${order.orderId}...');

    await Future.delayed(Duration(milliseconds: 300)); 
    //Mocking API call

    print('Payment successful for order:${order.orderId}!');

    return true;
  }
}