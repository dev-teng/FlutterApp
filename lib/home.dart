import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // for logout

//Home (Main App UI)
class Home extends StatefulWidget {
  final VoidCallback onLogout;

  Home({required this.onLogout});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  //List of products
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Apple',
      'price': 10.0,
      'image': 'assets/apple.jpg',
    },
    {
      'name': 'Banana',
      'price': 15.0,
      'image': 'assets/banana.jpg',
    },
    {
      'name': 'Grapes',
      'price': 30.0,
      'image': 'assets/grapes.jpg',
    },
    {
      'name': 'Watermelon',
      'price': 25.0,
      'image': 'assets/watermelon.jpg',
    },
    {
      'name': 'Orange',
      'price': 70.0,
      'image': 'assets/orange.jpg',
    },
    {
      'name': 'Dragon Fruit',
      'price': 80.0,
      'image': 'assets/dragon-fruit.jpg',
    },
  ];

  final List<Map<String, dynamic>> cart = [];
//This is to dynamically change the prolfile screen base on the user login
  User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  //This will use for GestureDetector and show when tapped or clicked
  void _showProductBottomSheet(BuildContext context, Map<String, dynamic> product, Function(int quantity) onAddToCart) {
    int quantity = 1;
    double totalPrice = product['price'];

    showModalBottomSheet(
      // This is the *outer* context passed into _showProductBottomSheet()
      // It tells Flutter where in the widget tree to attach the modal.
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // This is the *inner* context passed into the builder callback.
      // It is used to build the content of the bottom sheet.
      builder: (BuildContext context) {
        return StatefulBuilder(
          //setState in StatefulBuilder rebuilds only the part inside the builder.
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        product['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '₱${product['price'].toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'This is a healthy and fresh ${product['name'].toLowerCase()}.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  //This is for minus and plus button
                  Row(
                    children: [
                      Text(
                        'Quantity:',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                              totalPrice = product['price'] * quantity;
                            });
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {quantity++;
                          totalPrice = product['price'] * quantity;
                          });
                        },
                        icon: Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // ✅ Show Total Price dynamically
                  Row(
                    children: [
                      Text(
                        'Total:',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '₱${totalPrice.toStringAsFixed(2)}', // ✅ dynamically updates
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  //buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Add to cart logic here
                            Navigator.of(context).pop();
                            onAddToCart(quantity);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Selected product added to cart!'),
                                backgroundColor: Colors.amber[900],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Add to Cart'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Buy now logic here
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order placed successfully!'),
                                backgroundColor: Colors.amber[900],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Buy Now'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (var item in cart) {
      totalPrice += item['product']['price'] * item['quantity'];
    }
    List<Widget> _widgetOptions = <Widget>[
      //HOME SCREEN
      Padding(
        padding: EdgeInsets.all(9.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              //When tapped, it calls _showProductBottomSheet(...) to show more info.
              // This moves the setState call to the parent, ensuring the badge is rebuilt correctly.
              onTap: () => _showProductBottomSheet(context, product, (quantity) {
                setState(() {
                  int cartIndex = cart.indexWhere((item) => item['product']['name'] == product['name']);
                  if (cartIndex != -1) {
                    cart[cartIndex]['quantity'] += quantity;
                  } else {
                    cart.add({'product': product, 'quantity': quantity});
                  }
                });
              }),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10)),
                        child: Image.asset(
                          product['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber[300],
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10)),
                      ),
                      child: Text(
                        '₱${product['price'].toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // CART SCREEN
      cart.isEmpty
          ? Center(child: Text('Your cart is empty 🛒', style: TextStyle(fontSize: 24)))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                final product = item['product'];
                final quantity = item['quantity'];
                final total = product['price'] * quantity;

                return ListTile(
                  leading: Image.asset(product['image'], width: 50, height: 50),
                  title: Text(product['name']),
                  subtitle: Text('Qty: $quantity | Total: ₱${total.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Remove Item'),
                          content: Text('Are you sure you want to remove ${product['name']} from the cart?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  cart.removeAt(index); // Remove item
                                });
                                Navigator.of(context).pop(); // Close dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product['name']} removed from cart.'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              },
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₱${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Add checkout logic here
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Checkout'),
                    content: Text('Total amount to pay is ₱${totalPrice.toStringAsFixed(2)}.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            cart.clear();
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Checkout successful!'),
                              backgroundColor: Colors.amber[900],
                            ),
                          );
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[300],
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      // PROFILE SCREEN
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo
              Center(
                child:
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: currentUser?.photoURL != null
                        ? NetworkImage(currentUser!.photoURL!)
                        : AssetImage('assets/default_profile.png') as ImageProvider,
                  ),
                ),

              SizedBox(height: 16),

              //Email
              Center(
                child: Text(
                  currentUser?.email ?? 'No Email',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),

              // Settings Section
              Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),

              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Change Password'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Handle Change Password
                },
              ),
              Divider(),

              ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text('Notifications'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Handle Notifications
                },
              ),
              Divider(),

              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Help & Support'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Handle Help
                },
              ),
              Divider(),

              SizedBox(height: 30),

              // Logout Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();   // <-- logout from Firebase
                    widget.onLogout();                       // <-- update app state
                  },
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    // this is for AppBar Navigation
    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex != 0
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _onItemTapped(0);
          },
        )
            : null,
        title: Text(
          'Flutter App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 7,
                  top: 7,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${cart.length}', // Number of items in the cart
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        backgroundColor: Colors.amber[300],
        centerTitle: true,
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        //This tells the BottomNavigationBar which item is currently selected (active).
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}