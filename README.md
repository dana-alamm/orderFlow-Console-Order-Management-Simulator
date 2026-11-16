# 🚀 OrderFlow: Advanced Console-Based Order Management Simulator

A robust, enterprise-grade Dart console application simulating a real-world e-commerce checkout and order processing engine. Built to demonstrate clean architecture, defensive programming, and advanced asynchronous patterns.

---

## 🛠️ Tech Stack & Core Concepts
- **Language:** Dart
- **Architecture & Design Principles:** 
  - Dependency Injection (DI) & Inversion of Control (IoC)
  - Abstraction & Interfaces (`abstract class`)
  - Type Safety & Generics
- **Asynchronous Programming:** 
  - `Streams` & `async*` for real-time order tracking simulation.
  - `Futures` & `async/await` for simulated payment gateways.
- **Concurrency:** 
  - `Isolate.run()` for offloading heavy CPU-bound computations from the main thread.
- **Robust Error Handling:** 
  - Custom exceptions (`OutOfStockException`) and controlled defensive programming flows.

---

## 📂 Project Structure
```text
lib/
│
├── models/
│   ├── order.dart          # Order entity, items management, and state enums
│   └── product.dart        # OOP inheritance (Physical vs. Digital products)
│
├── services/
│   └── order_service.dart  # Business logic, stock deduction, and calculations
│
├── utils/
│   └── formatting.dart     # Abstraction layer for printing (ConsoleReceiptPrinter)
│
└── main.dart               # Entry point, negative test cases, and app demos
