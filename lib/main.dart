import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

void main() {
  runApp(HOME());
}

class HOME extends StatefulWidget {
  @override
  _HOMEState createState() => _HOMEState();
}


class _HOMEState extends State<HOME> {
  var _scaffoldKey;
  var _source;
  var _paymentMethod;
  var _currentSecret = "sk_test_51HyIcsFaX1cT9Hn9iKBlsTHdSpG5YkzlbPaBnbG7GolCZlYIni2M23wItwAhHaimaoB67qt3f1gCFT64TLr6Ner6008cYqT1zU";
  var _paymentIntent;
  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
        StripeOptions(
            publishableKey:"pk_test_51HyIcsFaX1cT9Hn9KQTQWuB0N6putvOe6Xd0IiLSZ7QEp5CXcXRNlI3R44Iy8MyM160b8vwBHFD0Uh2hsGjWJF3A008ybqWNRr",
            //YOUR_PUBLISHABLE_KEY
            merchantId: "Test",//YOUR_MERCHANT_ID
            androidPayMode: 'test')
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("STRIPE WITH FLUTTER"),
        ),
        body: Container(
          child:
          Column(
            children: [
              RaisedButton(
                child: Text("Create Source"),
                onPressed: () {
                  StripePayment.createSourceWithParams(SourceParams(
                    type: 'ideal',
                    amount: 2102,
                    currency: 'eur',
                    returnURL: 'example://stripe-redirect',
                  )).then((source) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Received ${source.sourceId}')));
                    // SnackBar(content: Text('Received ${source.sourceId}'));
                    print("auth success: "+ source.sourceId);
                    setState(() {
                      _source = source;
                    });
                  }).catchError((e){print(e.toString());});
                },
              ),
              RaisedButton(
                child: Text("Create Token with Card Form"),
                onPressed: () {
                  StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));

                    setState(() {
                      _paymentMethod = paymentMethod;
                    });
                  }).catchError((e){print("ERROR: "+e.toString());});
                },
              ),
              RaisedButton(
                child: Text("Confirm Payment Intent"),
                onPressed: _paymentMethod == null || _currentSecret == null
                    ? null
                    : () {
                  StripePayment.confirmPaymentIntent(
                    PaymentIntent(
                      clientSecret: _currentSecret,
                      paymentMethodId: _paymentMethod.id,
                    ),
                  ).then((paymentIntent) {
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
                    setState(() {
                      _paymentIntent = paymentIntent;
                    });
                  }).catchError((e){print(e.toString());});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


