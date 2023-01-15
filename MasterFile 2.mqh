//+------------------------------------------------------------------+
//|                                                 MasterFile 2.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


//  1........void ApplyTrailingStop( int magicNumber, double inpStopSteps ) --      not working
// 
//  2.............void TrailStop( int Ticketx, double ATR)--------------------      not working
//
//  3.............void CloseTradeLong(int MagicNo)----------------------------       closes all long
//
//  4.............void CloseTradeShort (int MgNo)-------------------------------    close all short
//
//  5.............void DrawTPBand (string Name,double Band)---------------------    draw bands on take profit percentages
//
//  6.............void DynamicTrailingStop( int magicNumber, int Tic)-----------    working dynamic stops
/// 7.............void TrailingStop (int Magic, int Docket, double Percent)----------  working trailing stop






//// Not working
void ApplyTrailingStop( int magicNumber, double inpStopSteps )


   {
   
      static int digits= (int) SymbolInfoInteger (Symbol(),SYMBOL_DIGITS);
      /// Trailing from close price
      
      
      double buyStopLoss;
      double sellStopLoss;
      
       
      
     
     double BuyProfitRange;
     double SellProfitRange;
     double progress;
     bool Buy50Stop, Buy60Stop, Buy70Stop,Buy80Stop, Buy90Stop;
     bool Sell50Stop, Sell60Stop,Sell70Stop,Sell80Stop,Sell90Stop;
     
        int count=OrdersTotal();
      
      for (int i=count-1;i>=0;i--)
      
      {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      
      static bool Buy50Stop=false;
      static bool Buy60Stop=false;
      static bool Buy70Stop=false;
      static bool Buy80Stop=false;
      static bool Buy90Stop=false;
      
      static bool Sell50Stop=false;
      static bool Sell60Stop=false;
      static bool Sell70Stop=false;
      static bool Sell80Stop=false;
      static bool Sell90Stop=false;     
      
      double StopSteps=SymbolInfoDouble(Symbol(), SYMBOL_POINT)*inpStopSteps;
      
      
      double step90=StopSteps;
      double step80=StopSteps*2;
      double step70=StopSteps*3;
      double step60=StopSteps*4;
      double step50=StopSteps*5;
      
      double BuyProfitRange= OrderTakeProfit()-OrderOpenPrice();
      double SellProfitRange= OrderOpenPrice()- OrderTakeProfit();
      
      double Buyband50= OrderOpenPrice()+(BuyProfitRange*0.5);
      double Buyband60=OrderOpenPrice()+(BuyProfitRange*0.6);
      double Buyband70=OrderOpenPrice()+(BuyProfitRange*0.7);
      double Buyband80=OrderOpenPrice()+(BuyProfitRange*0.8);
      double Buyband90=OrderOpenPrice()+(BuyProfitRange*0.9);
      
      
      double Sellband50= OrderOpenPrice()-(SellProfitRange*.5);
      double Sellband60=OrderOpenPrice()-(SellProfitRange*.6);
      double Sellband70=OrderOpenPrice()-(SellProfitRange*.7);
      double Sellband80=OrderOpenPrice()-(SellProfitRange*.8);
      double Sellband90= OrderOpenPrice()-(SellProfitRange*.9);    
      
      
      ///  DYNAMIC STOPS =====================================================
      
      if (OrderSymbol()==Symbol())
            if (OrderMagicNumber()==magicNumber)
               if (OrderType()==ORDER_TYPE_BUY)
                           
               
                { 
                     DrawTPBand ("BTP1",Buyband50);
                     DrawTPBand ("BTP2",Buyband60);
                     DrawTPBand ("BTP3",Buyband70);
                     DrawTPBand ("BTP4",Buyband80);
                     DrawTPBand ("BTP5",Buyband90);
                         
                  if (Bid > Buyband50)
                      if (Bid < Buyband60)
                     
                        {                       
                        Buy50Stop=true;
                        buyStopLoss = NormalizeDouble(Bid-step50, digits);
                     
                        if (buyStopLoss>OrderStopLoss())
                        
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLoss,OrderTakeProfit(),0,clrBlue);
                           Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                        }
                  if (Bid > Buyband60)
                     if (Bid< Buyband70)
                        {
                        Buy60Stop=true;
                        buyStopLoss = NormalizeDouble(Bid-step60, digits);
                        
                        if (buyStopLoss>OrderStopLoss())
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLoss,OrderTakeProfit(),0,clrBlue);
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                           }
                  if (Bid > Buyband70)
                    if (Bid< Buyband80)
                        {
                        Buy70Stop=true;
                        buyStopLoss = NormalizeDouble(Bid-step70, digits);
                        
                        if (buyStopLoss>OrderStopLoss())
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLoss,OrderTakeProfit(),0,clrBlue);
                           
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                          
                        }
                  if (Bid > Buyband80)
                    if (Bid<Buyband90)  
                        {                       
                        Buy80Stop=true;
                        buyStopLoss = NormalizeDouble(Bid-step80, digits);
                        
                        if (buyStopLoss>OrderStopLoss())
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLoss,OrderTakeProfit(),0,clrBlue);
                           
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                           }
                  if (Bid >  Buyband90)                       
                        {
                        Buy90Stop=true;
                        buyStopLoss = NormalizeDouble(Bid-StopSteps, digits);
                        
                        if (buyStopLoss>OrderStopLoss())
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLoss,OrderTakeProfit(),0,clrBlue);
                           
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                             
                        }
              
                  }            
                  
                  
         if (OrderSymbol()==Symbol())
            if (OrderMagicNumber()==magicNumber)
               if (OrderType()==ORDER_TYPE_SELL)
               
                { 
                
                  DrawTPBand ("STP1",Sellband50);
                  DrawTPBand ("STP2",Sellband60);
                  DrawTPBand ("STP3",Sellband70);
                  DrawTPBand ("STP4",Sellband80);
                  DrawTPBand ("STP5",Sellband90);
                  
                  
                  if (Ask < Sellband50)
                     if (Ask> Sellband60)
                        
                        {
                        Sell50Stop=true;
                        sellStopLoss = NormalizeDouble(Ask+step50, digits);
                        
                        if (sellStopLoss<OrderStopLoss())
                          OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLoss,OrderTakeProfit(),0,clrRed);
                         
                         Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                         
                        
                        }
                  if (Ask < Sellband60)
                     if (Ask> Sellband70)
                        {
                        Sell60Stop=true;
                        sellStopLoss = NormalizeDouble(Ask+step60, digits);
                        
                        if (sellStopLoss<OrderStopLoss())
                                     OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLoss,OrderTakeProfit(),0,clrRed);
                                    
                         Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                          }
                  if (Ask < Sellband70)
                    if (Ask> Sellband80)
                        {
                        Sell70Stop=true;
                        sellStopLoss = NormalizeDouble(Ask+step70, digits);
                        
                        if (sellStopLoss<OrderStopLoss())
                                     OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLoss,OrderTakeProfit(),0,clrRed);
                                     
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                          }
                  if (Ask < Sellband80)
                    if (Ask> Sellband90)
                        {
                        Sell80Stop=true;
                        sellStopLoss = NormalizeDouble(Ask+step80, digits);
                        
                        if (sellStopLoss<OrderStopLoss())
                                     OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLoss,OrderTakeProfit(),0,clrRed);
                                    
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                           }
                  if (Ask <Sellband90)
                        {
                        Sell90Stop=true;
                        sellStopLoss = NormalizeDouble(Ask+StopSteps, digits);
                        
                        if (sellStopLoss<OrderStopLoss())
                                     OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLoss,OrderTakeProfit(),0,clrRed);
                                     
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLoss+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                          }
                  }            
             }
Print("Error= "+ GetLastError());             
             
             }
                    
void TrailStop( int Ticketx, double ATR){                    

bool er;

double trailstop= iATR (Symbol(),Period(),14,1)*ATR;
double   BuyStop=Bid- trailstop;
double   BStop =NormalizeDouble(BuyStop,Digits);

double   SellStop=Ask+trailstop;
double   SStop =NormalizeDouble(SellStop,Digits);



    OrderSelect(Ticketx,SELECT_BY_TICKET);
      
        double previousStop= OrderStopLoss();
        
            if (OrderType()==ORDER_TYPE_BUY)
               if (previousStop<BStop)
                  
        
        { //OrderClose(TradeOne,OrderLots(),Ask,10,clrRed);
        er=OrderModify(OrderTicket(),OrderOpenPrice(),BStop,OrderTakeProfit(),0,clrRed);
            if (er!=true) Comment ("Error = "+GetLastError()); else Comment ("Order modified");
         }

            
             if (OrderType()==ORDER_TYPE_SELL)
             if (previousStop>SStop)
              
        
        { //OrderClose(TradeOne,OrderLots(),Ask,10,clrRed);
        er=OrderModify(OrderTicket(),OrderOpenPrice(),SStop,OrderTakeProfit(),0,clrRed);
            if (er!=true) Comment ("Error = "+GetLastError()); else Comment ("Order modified");
         }

            
                    
}





          
   
void CloseTradeLong(int MagicNo)
       
    {double TicketClose;
       
        for (int i=(OrdersTotal()-1);i>=0;i--)
     
          {
    
               if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) {Alert ("false result in the loop - loop=" + i +  "Order lots=  " + OrderLots());
      
                        return;}
   
      else {
      double bidprice= MarketInfo(OrderSymbol(),MODE_BID);
      if (OrderMagicNumber()== MagicNo)
         if (OrderSymbol()==Symbol())
    
             TicketClose= OrderClose(OrderTicket(),OrderLots(),bidprice,3,Red);
      
               int cnt=0;
                   while ((TicketClose==-1)&&(cnt<10))
         
         {
                Sleep (5000);
                 RefreshRates();
      
                 TicketClose= OrderClose(OrderTicket(),OrderLots(),bidprice,3,Red);
                  cnt++;
      
         }  
         
         if (TicketClose>0) 
                     { 
                        Alert (" TRADE EXITED ON MOVING AVERAGE !!!!!!!");
                           ExpertRemove();
      
                     }
      
     }}}


  
  
void CloseTradeShort (int MgNo)
       
    {double TicketClose;
       
        for (int i=(OrdersTotal()-1);i>=0;i--)
     
          {
    
               if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) {Alert ("false result in the loop - loop=" + i +  "Order lots=  " + OrderLots());
      
                        return;}
   
      else {
      double askprice= MarketInfo(OrderSymbol(),MODE_ASK);
      if (OrderMagicNumber()== MgNo)
         if (OrderSymbol()==Symbol())
    
             TicketClose= OrderClose(OrderTicket(),OrderLots(),askprice,3,Red);
      
               int cnt=0;
                   while ((TicketClose==-1)&&(cnt<10))
         
         {
                Sleep (5000);
                 RefreshRates();
      
                 TicketClose= OrderClose(OrderTicket(),OrderLots(),askprice,3,Red);
                  cnt++;
      
         }  
         
         if (TicketClose>0) 
                     { 
                        Alert (" TRADE EXITED ON MOVING AVERAGE !!!!!!!");
                           ExpertRemove();
      
                     }
      
     }}}

  
  
  
  
void DrawTPBand (string Name,double Band)
{


            
             double linestart= iTime(Symbol(),Period(),15);
             double lineend = iTime(Symbol(),Period(),0);
            ObjectDelete(0,Name);
            ObjectCreate (Name,OBJ_TREND,0,
            linestart,Band, 
            lineend,Band);
            ObjectSetInteger(0,Name,OBJPROP_COLOR,clrBeige);
            ObjectSetInteger(0,Name,OBJPROP_WIDTH,1);
            ObjectSetInteger(0,Name,OBJPROP_STYLE,STYLE_DOT);
            ObjectSetInteger(0,Name,OBJPROP_RAY_RIGHT, true);
 

}





void DynamicTrailingStop( int magicNumber, int Tic)


   {
   
      static int digits= (int) SymbolInfoInteger (Symbol(),SYMBOL_DIGITS);
      /// Trailing from close price
      
      
      double buyStopLossx;
      double sellStopLossx;
      
       
      
     
    // double progress;
    
   
      OrderSelect(Tic,SELECT_BY_TICKET,MODE_TRADES);
      
      static bool Buy40Stopx=false;
      static bool Buy60Stopx=false;
      static bool Buy80Stopx=false;
      static bool Buy90Stopx=false;
      
      static bool Sell40Stopx=false;
      static bool Sell60Stopx=false;
      static bool Sell80Stopx=false;
      static bool Sell90Stopx=false;     
           
      
      double  BuyProfitRangex= OrderTakeProfit()-OrderOpenPrice();
      double SellProfitRangex= OrderOpenPrice()- OrderTakeProfit();
      
      
      double sellstep90x=SellProfitRangex*.1;
      double sellstep80x= SellProfitRangex*.2;
      double sellstep60x=SellProfitRangex*.3;
      double sellstep40x=SellProfitRangex*0.4;

      double buystep90x=BuyProfitRangex*.1;
      double buystep80x= BuyProfitRangex*.2;
      double buystep60x=BuyProfitRangex*.3;
      double buystep40x=BuyProfitRangex*0.4;
      
      
      double Buyband40x= OrderOpenPrice()+(BuyProfitRangex*0.4);
      double Buyband60x=OrderOpenPrice()+(BuyProfitRangex*0.6);
      double Buyband70x=OrderOpenPrice()+(BuyProfitRangex*0.7);
      double Buyband80x=OrderOpenPrice()+(BuyProfitRangex*0.8);
      double Buyband90x=OrderOpenPrice()+(BuyProfitRangex*0.9);
      
      
      double Sellband40x= OrderOpenPrice()-(SellProfitRangex*.4);
      double Sellband60x=OrderOpenPrice()-(SellProfitRangex*.6);
      double Sellband70x=OrderOpenPrice()-(SellProfitRangex*.7);
      double Sellband80x=OrderOpenPrice()-(SellProfitRangex*.8);
      double Sellband90x= OrderOpenPrice()-(SellProfitRangex*.9);    
      
      
      ///  DYNAMIC STOPS =====================================================
      
      if (OrderSymbol()==Symbol())
            if (OrderMagicNumber()==magicNumber)
               if (OrderType()==ORDER_TYPE_BUY)
                           
               
                { 
                     DrawTPBand ("BTP1",Buyband40x);
                     DrawTPBand ("BTP2",Buyband60x);
                     DrawTPBand ("BTP4",Buyband80x);
                     DrawTPBand ("BTP5",Buyband90x);
                         
                  if (Bid > Buyband40x)
                      if (Bid < Buyband60x)
                     
                        {                       
                        Buy40Stopx=true;
                        buyStopLossx = NormalizeDouble(Bid-buystep40x, digits);
                     
                        if (buyStopLossx>OrderStopLoss())
                        
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLossx,OrderTakeProfit(),0,clrBlue);
                           Print(" xxx Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLossx+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                        }
                  if (Bid > Buyband60x)
                     if (Bid< Buyband80x)
                        {
                        Buy60Stopx=true;
                        buyStopLossx = NormalizeDouble(Bid-buystep60x, digits);
                        
                        if (buyStopLossx>OrderStopLoss())
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLossx,OrderTakeProfit(),0,clrBlue);
                          Print(" xxx Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLossx+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                           }
                  
                  if (Bid > Buyband80x)
                    if (Bid<Buyband90x)  
                        {                       
                        Buy80Stopx=true;
                        buyStopLossx = NormalizeDouble(Bid-buystep80x, digits);
                        
                        if (buyStopLossx>OrderStopLoss())
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLossx,OrderTakeProfit(),0,clrBlue);
                           
                          Print(" xxx Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLossx+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                           }
                  if (Bid >  Buyband90x)                       
                        {
                        Buy90Stopx=true;
                        buyStopLossx = NormalizeDouble(Bid-buystep90x, digits);
                        
                        if (buyStopLossx>OrderStopLoss())
                           OrderModify(OrderTicket(), OrderOpenPrice(),buyStopLossx,OrderTakeProfit(),0,clrBlue);
                           
                          Print(" xxx Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  Buy stoploss = "+buyStopLossx+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                             
                        }
              
                  }            
                  
                  
         if (OrderSymbol()==Symbol())
            if (OrderMagicNumber()==magicNumber)
               if (OrderType()==ORDER_TYPE_SELL)
               
                { 
                
                  DrawTPBand ("STP1",Sellband40x);
                  DrawTPBand ("STP2",Sellband60x);
                  DrawTPBand ("STP4",Sellband80x);
                  DrawTPBand ("STP5",Sellband90x);
                  
                  
                  if (Ask < Sellband40x)
                     if (Ask> Sellband60x)
                        
                        {
                        Sell40Stopx=true;
                        sellStopLossx = NormalizeDouble(Ask+sellstep40x, digits);
                        
                        if (sellStopLossx<OrderStopLoss())
                          OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLossx,OrderTakeProfit(),0,clrRed);
                         
                         Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLossx+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                         
                        
                        }
                  if (Ask < Sellband60x)
                     if (Ask> Sellband80x)
                        {
                        Sell60Stopx=true;
                        sellStopLossx = NormalizeDouble(Ask+sellstep60x, digits);
                        
                        if (sellStopLossx<OrderStopLoss())
                                     OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLossx,OrderTakeProfit(),0,clrRed);
                                    
                         Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLossx+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                          }
                  
                  if (Ask < Sellband80x)
                    if (Ask> Sellband90x)
                        {
                        Sell80Stopx=true;
                        sellStopLossx = NormalizeDouble(Ask+sellstep80x, digits);
                        
                        if (sellStopLossx<OrderStopLoss())
                                     OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLossx,OrderTakeProfit(),0,clrRed);
                                    
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLossx+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                           }
                  if (Ask <Sellband90x)
                        {
                        Sell90Stopx=true;
                        sellStopLossx = NormalizeDouble(Ask+sellstep90x, digits);
                        
                        if (sellStopLossx<OrderStopLoss())
                                     OrderModify(OrderTicket(), OrderOpenPrice(),sellStopLossx,OrderTakeProfit(),0,clrRed);
                                     
                          Print(" Order No =" +OrderTicket()+ "  Order open price= "+OrderOpenPrice()+"  sell stoploss = "+sellStopLossx+ "  take prof= "+ OrderTakeProfit()+ " order expiration= "+ OrderExpiration());
                          }
                  }            
             
Print("Error= "+ GetLastError());             
             
             }
  
  
  void TrailingStop (int Magic, int TicNo, double StopSize)
  {
  
  
  OrderSelect(TicNo,SELECT_BY_TICKET,MODE_TRADES);
  
  
  
  
  if (OrderType()==ORDER_TYPE_BUY)
    if(OrderMagicNumber()==Magic)
      if (OrderSymbol()==Symbol())
  
  {
  double Buy_Stop= Bid-StopSize;
  Print ("++++++++++++++++++  "+Buy_Stop);
  DrawTPBand ("BS",Buy_Stop);
  if (OrderStopLoss()<Buy_Stop) OrderModify(OrderTicket(), OrderOpenPrice(),NormalizeDouble(Buy_Stop,Digits),0,0,clrBlue);  
  return;}



  if (OrderType()==ORDER_TYPE_SELL)
    if(OrderMagicNumber()==Magic)
      if (OrderSymbol()==Symbol())
  
  {
  double Sell_Stop= Ask+StopSize;
  DrawTPBand ("sst",Sell_Stop);
  Print("++++++++++++++  +"+Sell_Stop);
  if (OrderStopLoss()>Sell_Stop) OrderModify(OrderTicket(), OrderOpenPrice(),NormalizeDouble(Sell_Stop,Digits),0,0,clrBlue);  
  return;}

}                  

  
   int PendingOrderOpen (ENUM_ORDER_TYPE orderType_,double inpOrderSize_,string inpTradeComments_,int inpMagicNumber_, double orderPrice_, double stopLoss_, double takeProfit_, datetime expire){
      
      int   ticket_;
      double openPrice_;
      double stopLossPrice_;
      double takeProfitPrice_;
      
 //     int digits_ = Digits();
 //  double spread_= MarketInfo(Symbol(),MODE_SPREAD);
 //  if (digits_==4)spread_=spread_/100;
 //  if (digits_==5) spread_=spread_/100;
 //  if (digits_==2) spread_=spread_/10;
       
      
       
       Comment ("\n\r order price passed to function = "+orderPrice_+  " Stoploss = "+stopLoss_+ " take profit=  "+takeProfit_);
       
       double StopLevel_ =MarketInfo(Symbol(), MODE_STOPLEVEL);
      
      // caclulate the open price, take profit and stoploss price based on the order type
      // 4= BUY STOP
      if (orderType_==OP_BUYSTOP){
         openPrice_    = NormalizeDouble(orderPrice_, Digits());      
         stopLossPrice_ = NormalizeDouble(openPrice_-stopLoss_,Digits());
         takeProfitPrice_ = NormalizeDouble(openPrice_+takeProfit_,Digits());
         
      
      if (openPrice_ - Ask < StopLevel_ * _Point) openPrice_ = Ask + StopLevel_ * _Point;
        if (openPrice_ - stopLossPrice_ < StopLevel_ * _Point) stopLossPrice_ = openPrice_ - StopLevel_ * _Point;
        if (takeProfitPrice_ - openPrice_ < StopLevel_ * _Point) takeProfitPrice_ = openPrice_ + StopLevel_ * _Point;
    

        /// 5= SELL STOP
      } else if (orderType_==OP_SELLSTOP){
         openPrice_ = NormalizeDouble (orderPrice_, Digits());
         stopLossPrice_ =  NormalizeDouble(openPrice_+stopLoss_,Digits());
         takeProfitPrice_ = NormalizeDouble(openPrice_-takeProfit_,Digits());
         
         if (Bid - openPrice_ < StopLevel_ * _Point) openPrice_ = Bid - StopLevel_ * _Point;
        if (stopLossPrice_ - openPrice_ < StopLevel_ * _Point) stopLossPrice_ = openPrice_ + StopLevel_ * _Point;   
        if (openPrice_ - takeProfitPrice_ < StopLevel_ * _Point) takeProfitPrice_ = openPrice_ - StopLevel_ * _Point;
         
         
      
      }else{ 
      // this function works with buy or sell
         return (-1);
      }
      
      double volume_=NormalizeDouble(inpOrderSize_,Digits());
      
      
      
      ticket_ = OrderSend (Symbol(), orderType_,volume_, openPrice_,10,stopLossPrice_, takeProfitPrice_,inpTradeComments_, inpMagicNumber_,expire);
      
      if (orderType_==OP_BUYSTOP)
      {
            Print (      "long entry - entry pice= "+openPrice_+ " stop = " + stopLossPrice_+ "  take profit = " + takeProfitPrice_+
                    "\r\n\ Error="+GetLastError());
                    
/////debugging loop ------------------------------------------------------------------------------------------------------
                    
                
      }
      if (orderType_== OP_SELLSTOP)
      {
    
         Print (     "short entry - entry pice= "+openPrice_+ " stop = " + stopLossPrice_+ "  take profit = " + takeProfitPrice_+
              "\r\n Error=  "+GetLastError());
             

    
      }  
      
      
      
      return (ticket_);
}
      