import 'dart:isolate';

import 'package:orderflow/models/order.dart';
import 'package:orderflow/models/product.dart';
import 'package:orderflow/services/order_service.dart';
import 'package:orderflow/utils/formatting.dart';

int heavyComputation(){
  int total=0;
  for(int i=0;i<500000000;i++){
    total+=1;

  }
  return total;
}
void main()async{
print('--- Phase 6: Isolate Demo ---');
int isolateResult=await Isolate.run(heavyComputation);
print('Isolate Result: $isolateResult\n');

print('---System setup---');
ReceiptPrinter consolePrinter=ConsoleReceiptPrinter();

List<Product>storeCatalog=[
   PhysicalProduct(sku: 'P01', name: 'Notebook', price: 12.00, initialStock: 4),
   PhysicalProduct(sku: 'P02', name: 'Bottle', price: 18.00, initialStock: 6),
   DigitalProduct(sku: 'D01', name: 'eBook', price: 9.00),
   DigitalProduct(sku: 'D02', name:'Template', price: 15.00),
];
OrderService cashier=OrderService(
  catalog:storeCatalog, 
  printer: consolePrinter
  );
  print('--- Negative Cases (Controlled Errors) ---');
  try{
    cashier.placeOrder('ORD-ERR1', {'P01':5});
  }on OutOfStockException catch(e){
    print('Caught an Error: $e');
  }

  cashier.placeOrder('ORD-ERR2', {'Z99': 1});

  cashier.placeOrder('ORD-ERR3', {'P02':0});
  print('\n----------------------------------------\n');

  print('--- Phase 3 & 4: Exact Demo Scenario ---');

  cashier.placeOrder('ORD-101', {'P01':2,'D01':1},couponCode: 'SAVE10');

  
  print('\n All systems tested successfully');
}