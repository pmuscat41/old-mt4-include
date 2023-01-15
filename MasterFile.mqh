//+------------------------------------------------------------------+
//|                                                   MasterFile.mqh |
//|                                      Copyright 2022, Paul Muscat |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Paul Muscat"
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




//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
///**
///orderOpen- simple function to open a new order
///newBar()- only trade on a new bar
////newBarCustom - custom newbar- supply timeframe
///Above200MA_Day ()    returns true if price >200SMA Daily
///GetAveragePeriodRange12 ()  - returns average range 12 bars for given time period
///GetAveragePeriodRange6 ()   - returns average range 6 bars for given time period
/// GetPivot    -reurns the pivot for a given timeframe and barshift
////CheckNewShortPivotTrend -  returns true for a new short trend based on thre pivots and a ref moving average
///CheckNewShortPivotTurningPoint- returns true of pivot change direction- short
///CheckContinueShortPivotTrend -   checks to see if short trend in placebased on thre pivots and a ref moving average
////CheckNewLongPivotTrend -  returns true if a new long tred based on three pivots and a ref moving average
////CheckNewShortPivotTurningPoint-returns true of pivot change direction- short
///CheckContinueLongPivotTrend -    checks to see if short trend in placebased on thre pivots and a ref moving average
////DrawThree4HrPivots()-  draws three 4hr pivots 
////AdjustLotzizeATR - adjusts lotsize based on supplied ATR short, ATR long and Lotsize
/// GetHVG () - returns daily Historic Volatility
///GetL3_Day () - get L3 camarilla
///GetH3_Day () - get H3 camarilla
///GetL4_Day () - get L3 camarilla
///GetH4_Day () - get H3 camarilla
///GetHVDays (string security, int DaysPeriod) - gets Historic Volatility for a required period and Symbol
//  CalculateLotsize - calculates lot size to order based on sl and amount to risk

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


  //simple function to open a new order 
   
   int orderOpen (ENUM_ORDER_TYPE orderType, double stopLoss, double takeProfit,double  inpOrderSize,string  inpTradeComments,int  inpMagicNumber )
   
   
   {
      
      int   ticket=-1;
      double openPrice;
      double stopLossPrice;
      double takeProfitPrice;
      
      // caclulate the open price, take profit and stoploss price based on the order type
      //
      
      

 int count = 0;
            while ((ticket == -1) && (count < 10))
      
 {  
      
      if (orderType==ORDER_TYPE_BUY){
         RefreshRates();
         openPrice    = NormalizeDouble(SymbolInfoDouble(Symbol(), SYMBOL_ASK), Digits());
      
         //Ternary operator, because it makes things look neat
         //   if stopLoss==0.0){
     
         //stopLosssPrice = 0.0} 
         //   else {
         //    stopLossPrice = NormalizedDouble (openPrice - stopLoss, Digist());
         //
      
         stopLossPrice = (stopLoss==0.0)? 0.0: NormalizeDouble(openPrice-stopLoss,Digits());
         takeProfitPrice = (takeProfit==0.0)? 0.0: NormalizeDouble(openPrice+takeProfit,Digits());
      }else if (orderType==ORDER_TYPE_SELL){
         RefreshRates(); openPrice = NormalizeDouble (SymbolInfoDouble(Symbol(), SYMBOL_BID), Digits());
         stopLossPrice = (stopLoss==0.0)? 0.0: NormalizeDouble(openPrice+stopLoss,Digits());
         takeProfitPrice = (takeProfit==0.0)? 0.0: NormalizeDouble(openPrice-takeProfit,Digits());
      
      }else{ 
      // this function works with buy or sell
         return (-1);
      }
      
      ticket = OrderSend (Symbol(), orderType,inpOrderSize, openPrice,0,stopLossPrice, takeProfitPrice,inpTradeComments, inpMagicNumber);
      
      Print ("order type= "+orderType+ "Open Price =  "+ openPrice + " Stoploss = "+  stopLossPrice + "  take profit = " + takeProfitPrice);
      if (ticket!= -1) Comment ("\r\n\ Error="+GetLastError());
      count++; 
      
  }    
      
      return (ticket);
      
      
}
      

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

// true or false has bar changed

bool newBar(){

   datetime          currentTime =  iTime(Symbol(),Period(),0);// get openong time of bar
   static datetime   priorTime =   currentTime; // initialized to prevent trading on first bar
   bool              result =      (currentTime!=priorTime); //Time has changed
   priorTime               =        currentTime; //reset for next time
   return(result);
   }


//+------------------------------------------------------------------+


bool newBarCustom(ENUM_TIMEFRAMES Timefr){

   datetime          currentTime =  iTime(Symbol(),Timefr,0);// get openong time of bar
   static datetime   priorTime =   currentTime; // initialized to prevent trading on first bar
   bool              result =      (currentTime!=priorTime); //Time has changed
   priorTime               =        currentTime; //reset for next time
   return(result);
   }



//+------------------------------------------------------------------+


bool newBar15m(){

   datetime          currentTime =  iTime(Symbol(),PERIOD_M15,0);// get openong time of bar
   static datetime   priorTime =   currentTime; // initialized to prevent trading on first bar
   bool              result =      (currentTime!=priorTime); //Time has changed
   priorTime               =        currentTime; //reset for next time
   return(result);
   }










//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

bool Above200MA_Day () {
   double TwoHunMa = iMA(Symbol(),PERIOD_D1,200,0,MODE_SMMA, PRICE_CLOSE,0);
   if (iClose (Symbol(),Period(),0)>TwoHunMa) return (true); 
      else return (false);
   }
   

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+   


double GetAveragePeriodRange12 (ENUM_TIMEFRAMES period)

{

double d1=iHigh(Symbol(),period,1)-iLow (Symbol(),Period(),1);
double d2=iHigh(Symbol(),period,2)-iLow (Symbol(),Period(),2);
double d3=iHigh(Symbol(),period,3)-iLow (Symbol(),Period(),3);
double d4=iHigh(Symbol(),period,4)-iLow (Symbol(),Period(),4);
double d5=iHigh(Symbol(),period,5)-iLow (Symbol(),Period(),5);
double d6=iHigh(Symbol(),period,6)-iLow (Symbol(),Period(),6);


double d7=iHigh(Symbol(),period,7)-iLow (Symbol(),Period(),7);
double d8=iHigh(Symbol(),period,8)-iLow (Symbol(),Period(),8);
double d9=iHigh(Symbol(),period,9)-iLow (Symbol(),Period(),9);
double d10=iHigh(Symbol(),period,10)-iLow (Symbol(),Period(),10);
double d11=iHigh(Symbol(),period,11)-iLow (Symbol(),Period(),11);
double d12=iHigh(Symbol(),period,12)-iLow (Symbol(),Period(),12);

double Average= (d1+d2+d3+d4+d5+d6+d7+d8+d9+d10+d11+d12)/12;
return (Average);

}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+   


double GetAveragePeriodRange6 (ENUM_TIMEFRAMES period)

{

double d1=iHigh(Symbol(),period,1)-iLow (Symbol(),period,1);
double d2=iHigh(Symbol(),period,2)-iLow (Symbol(),period,2);
double d3=iHigh(Symbol(),period,3)-iLow (Symbol(),period,3);
double d4=iHigh(Symbol(),period,4)-iLow (Symbol(),period,4);
double d5=iHigh(Symbol(),period,5)-iLow (Symbol(),period,5);
double d6=iHigh(Symbol(),period,6)-iLow (Symbol(),period,6);


double Average= (d1+d2+d3+d4+d5+d6)/6;
return (Average);

}


double GetPivot (ENUM_TIMEFRAMES period, int periods_shift)

{

double High1= iHigh(Symbol(),period,periods_shift);
double Low1= iLow(Symbol(),period,periods_shift);
double Close1= iClose(Symbol(),period,periods_shift);
double Pivot1= (High1+Low1+Close1)/3;

return(Pivot1);

}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+   

bool CheckNewShortPivotTrend (double Pivot1, double Pivot2, double Pivot3, double refMA)

{

if ((Pivot3<Pivot2)
   && (Pivot1<Pivot2)
      && (Pivot1<refMA))
       return (true);
         else return (false);
}      
   
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


bool CheckNewShortPivotTurningPoint (double Pivot1, double Pivot2, double Pivot3)

{

if ((Pivot3<Pivot2)
   && (Pivot1<Pivot2))
     
       return (true);
         else return (false);
}      
   
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+   

bool CheckContinueShortPivotTrend (double Pivot1, double Pivot2, double Pivot3, double refMA)

{
   
if (Pivot3>Pivot2
    && Pivot1<Pivot2
     && Pivot1<refMA
         && Pivot2<refMA
            && Pivot3<refMA)
               return (true);
                  else return (false);
                  
                  
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+   

bool CheckNewLongPivotTrend (double Pivot1, double Pivot2, double Pivot3, double refMA)

{

if (   Pivot3>Pivot2
         && Pivot1>Pivot2
            && Pivot1<refMA
               && Pivot1>refMA)
                    return (true);
                      else return (false);
}      
   
   

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+



bool CheckNewLongPivotTurningPoint (double Pivot1, double Pivot2, double Pivot3)

{

if (   Pivot3>Pivot2
         && Pivot1>Pivot2)
           
                    return (true);
                      else return (false);
}      
   
   



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+   

bool CheckContinueLongPivotTrend (double Pivot1, double Pivot2, double Pivot3, double refMA)

{
   
if (Pivot2>Pivot3
    && Pivot1>Pivot2
     && Pivot1>refMA
         && Pivot2>refMA
            && Pivot3>refMA)
               return (true);
                  else return (false);
                  
   
  } 
   

void DrawThree4HrPivots(double Pivot1, double Pivot2, double Pivot3)

{
datetime linestart;
datetime lineend;
   
             linestart= iTime(Symbol(),PERIOD_H4,6);
             lineend = iTime(Symbol(),PERIOD_H4,0);
            ObjectDelete(0,"P1");
            ObjectCreate ("P1",OBJ_TREND,0,
            linestart,Pivot1, 
            lineend,Pivot1);
            ObjectSetInteger(0,"P1",OBJPROP_COLOR,clrBlue);
            ObjectSetInteger(0, "P1",OBJPROP_WIDTH,3);
            ObjectSetInteger(0, "P1",OBJPROP_RAY_RIGHT, false);
     
            
      
      
      
             linestart= iTime(Symbol(),PERIOD_H4,12);
             lineend = iTime(Symbol(),PERIOD_H4,7);
             
            ObjectDelete(0,"P2");
            ObjectCreate ("P2",OBJ_TREND,0,
            linestart,Pivot2, 
            lineend,Pivot2);
            ObjectSetInteger(0,"P2",OBJPROP_COLOR,clrBlue);
            ObjectSetInteger(0, "P2",OBJPROP_WIDTH,3);
            ObjectSetInteger(0, "P2",OBJPROP_RAY_RIGHT, false);
      
             
      
      
      
      
      
             linestart= iTime(Symbol(),PERIOD_H4,13);
             lineend = iTime(Symbol(),PERIOD_H4,18);
            ObjectDelete(0,"P3"); 
            ObjectCreate ("P3",OBJ_TREND,0,
            linestart,Pivot3, 
            lineend,Pivot3);
            ObjectSetInteger(0,"P3",OBJPROP_COLOR,clrBlue);
            ObjectSetInteger(0, "P3",OBJPROP_WIDTH,3);
            ObjectSetInteger(0, "P3",OBJPROP_RAY_RIGHT, false);
      
               

}

double AdjustLotsizeATR (double Lotsize, int ATRShort, int ATRLong)
   {
   
     
         double ATR                  = iATR(Symbol(),Period(),ATRShort,1);
         double ATRLomg                  = iATR(Symbol(),Period(),ATRLong,1);
         
         double orderSizeAdjust= ATRLong/ATR;
         double orderSize= orderSizeAdjust*Lotsize;
         return (orderSize);
         
         }
         

double GetHVG (){

      double Price1=iClose(Symbol(),Period(),1);
      double Price2= iClose(Symbol(),Period(),2);
      double Price3= iClose(Symbol(),Period(),3);
      double Price4= iClose(Symbol(),Period(),4);
      
      
      double log1=MathLog (Price1);
      double log2=MathLog (Price2);
      double log3=MathLog (Price3);
      double log4=MathLog (Price4);
          
      
      double Dif1= log1-log2;
      double Dif2= log2=log3;
      double Dif3=log3-log4;
      
      double mean=(Dif1+Dif2+Dif3)/3;
      
      double m1=(Dif1-mean)*(Dif1-mean);
      double m2=(Dif2-mean)*(Dif2-mean);
      double m3=(Dif3-mean)*(Dif3-mean);
      
      double variance=(m1+m2+m3)/3;
      double standardDeviation = MathSqrt(variance);
      double HVG= standardDeviation*MathSqrt(260)*10;
      return (HVG);
  }    
      
double GetH3_Day ()
      {
      
      
 double     High_1=iHigh(Symbol(),PERIOD_MN1, 1);
 double     Low_1=iLow(Symbol(),PERIOD_MN1,1);
 double      Close_1=iClose (Symbol(),PERIOD_MN1,1);
 double     Range_1=High_1-Low_1; 
 double     H3= Close_1+(Range_1*1.1/4);
 return (H3);


}

double GetL3_Day ()
      {
      
      
 double     High_1=iHigh(Symbol(),PERIOD_MN1, 1);
 double     Low_1=iLow(Symbol(),PERIOD_MN1,1);
 double      Close_1=iClose (Symbol(),PERIOD_MN1,1);
 double     Range_1=High_1-Low_1; 
 double     L3= Close_1-(Range_1*1.1/4);
 return (L3);


}


double GetH4_Day ()
      {
      
      
 double     High_1=iHigh(Symbol(),PERIOD_MN1, 1);
 double     Low_1=iLow(Symbol(),PERIOD_MN1,1);
 double      Close_1=iClose (Symbol(),PERIOD_MN1,1);
 double     Range_1=High_1-Low_1; 
 double     H4= Close_1+(Range_1*1.1/2);
 return (H4);


}

double GetL4_Day ()
      {
      
      
 double     High_1=iHigh(Symbol(),PERIOD_W1, 1);
 double     Low_1=iLow(Symbol(),PERIOD_W1,1);
 double      Close_1=iClose (Symbol(),PERIOD_W1,1);
 double     Range_1=High_1-Low_1; 
 double     L4= Close_1-(Range_1*1.1/2);
 return (L4);


}


   //simple function to open a pending new order 
   
   int PendingStopOrderOpen (ENUM_ORDER_TYPE orderType, double orderPrice, double stopLoss, double takeProfit,double inpOrderSize, string   inpTradeComments,int   inpMagicNumber, datetime Expire){
      
      int   ticket;
      double openPrice;
      double stopLossPrice;
      double takeProfitPrice;
      
      int digits = Digits();
   double spread= MarketInfo(Symbol(),MODE_SPREAD);
   if (digits==4)spread=spread/100;
   if (digits==5) spread=spread/100;
   if (digits==2) spread=spread/10;
       
      
       
       Comment ("\n\r order price passed to function = "+orderPrice+  " Stoploss = "+stopLoss+ " take profit=  "+takeProfit);
       
       
      
      // caclulate the open price, take profit and stoploss price based on the order type
      //
      if (orderType==OP_BUYSTOP){
         openPrice    = NormalizeDouble(orderPrice, Digits());      
         stopLossPrice = NormalizeDouble(openPrice-stopLoss,Digits());
         takeProfitPrice = NormalizeDouble(openPrice+takeProfit,Digits());
    

        
      } else if (orderType==OP_SELLSTOP){
         openPrice = NormalizeDouble (orderPrice, Digits());
         stopLossPrice =  NormalizeDouble(openPrice+stopLoss,Digits());
         takeProfitPrice = NormalizeDouble(openPrice-takeProfit,Digits());
         
      
      }else{ 
      // this function works with buy or sell
         return (-1);
      }
      
      double volume=NormalizeDouble(inpOrderSize,Digits());
      ticket = OrderSend (Symbol(), orderType,volume, openPrice,0,stopLossPrice, takeProfitPrice,inpTradeComments, inpMagicNumber,Expire);
      
      if (orderType==OP_BUYSTOP)
      {
            Comment ( "Old order function passed the folliowing -  stop = " + stopLossPrice+ "  take profit = " + takeProfitPrice+
                    "\r\n\ Error= "+GetLastError());
                    
/////debugging loop ------------------------------------------------------------------------------------------------------
                    
                
      }
      if (orderType== OP_SELLSTOP)
      {
    
         Comment ( " Old order function passed the following- stop = " + stopLossPrice+ "  take profit = " + takeProfitPrice+
              "\r\n Error=  "+GetLastError());
             

    
      }  
      
      
      
      return (ticket);
}
    





double GetHVDays (string security, int DaysPeriod,double meandays){

      
double Price[200];
double logs[200];


int j;

int Maxdata=DaysPeriod+1;
for (int i=0;i<Maxdata;i++)
      
      {
      j=i+1;
       Price[i]=iClose(security,PERIOD_D1,j);
       logs[i]=MathLog (Price[i]);
      }
      
  double Dif[200];
  
for (int i=0;i<DaysPeriod;i++)
     
      {   
      j=i+1; 
       Dif[i]= logs[i]-logs[j];
      }
     
      double mean=0;
      double getmean=0;
      
for (int i=0;i<DaysPeriod;i++)
      { 
       getmean=getmean+Dif[i] ;
       }
      
      
  mean=getmean/meandays;    
      

double m[200];
    
for (int i=0;i<DaysPeriod;i++)
      
      { 
      
       m[i]= MathPow ((Dif[i]-mean),2);
      
      }

      





      
      double getvariance=0;
      double variance=0;
          
for (int i=0;i<DaysPeriod;i++)
      
      {
       getvariance=getvariance+m[i];
      
      }
      
      variance=getvariance/meandays;
            
      double standardDeviation = MathSqrt(variance);
      double HVG= standardDeviation*MathSqrt(260)*100;
      return (HVG);

  }    
      

 




///____________________________________________________________________________






double GetHVDays_datacheck (string security, int DaysPeriod,double meandays){

      
double Price[200];
double logs[200];


int j;

int Maxdata=DaysPeriod+1;
for (int i=0;i<Maxdata;i++)
      
      {
      j=i+1;
       Price[i]=iClose(security,PERIOD_D1,j);
       logs[i]=MathLog (Price[i]);
      }
      
  double Dif[200];
  
for (int i=0;i<DaysPeriod;i++)
     
      {   
      j=i+1; 
       Dif[i]= logs[i]-logs[j];
      }
     
      double mean=0;
      double getmean=0;
      
for (int i=0;i<DaysPeriod;i++)
      { 
       getmean=getmean+Dif[i] ;
       }
      
      
  mean=getmean/meandays;    
      
Alert ("mean log diff=  "+mean);      

double m[200];
    
for (int i=0;i<DaysPeriod;i++)
      
      { 
      
       m[i]= MathPow ((Dif[i]-mean),2);
      
      }

/// File output for price[], logs [], m[]


      string   mySpreadsheet="Spreadsheet2.csv";
      
      int mySpreadsheetHandle= FileOpen(mySpreadsheet,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
      FileSeek(mySpreadsheetHandle,0,SEEK_END);
      
      FileWrite(mySpreadsheetHandle,"Close Price","Log","Dif in Logs","mean log diff","variance squared");
      
       
for (int i=0;i<DaysPeriod+1;i++)
      
      { 
       
      FileWrite(mySpreadsheetHandle,Price[i],logs[i],Dif[i],mean,m[i]);
      
      }
    
      
      FileClose(mySpreadsheetHandle);
      





      
      double getvariance=0;
      double variance=0;
          
for (int i=0;i<DaysPeriod;i++)
      
      {
       getvariance=getvariance+m[i];
      
      }
      
      variance=getvariance/meandays;
            
Alert ("Variance ="+variance);
      double standardDeviation = MathSqrt(variance);
      double HVG= standardDeviation*MathSqrt(260)*100;
      return (HVG);

  }    
      

 
double CalculateLotsize ( double stopLossx, double PercentToRiskx,double inpCashMinx)

{

   double tickSize      = SymbolInfoDouble( Symbol(), SYMBOL_TRADE_TICK_SIZE );
   double tickValue     = SymbolInfoDouble( Symbol(), SYMBOL_TRADE_TICK_VALUE );
   double point         = SymbolInfoDouble( Symbol(), SYMBOL_POINT );
   double ticksPerPoint = tickSize / point;
   double pointValue    = tickValue / ticksPerPoint;

   double riskAmount= (PercentToRiskx/100) * AccountBalance();
      if (riskAmount>AccountFreeMargin())
         if (AccountFreeMargin()>inpCashMinx)
            riskAmount=AccountFreeMargin()- inpCashMinx; else return (0.1);   
 

 int digits = Digits();
         if (digits==4)  stopLossx=stopLossx*1000;
          if (digits==5) stopLossx=stopLossx*100000;
          if (digits==3) stopLossx=stopLossx*1000; 
 
 
 
 
 
double riskLots; 

if (stopLossx*pointValue!=0) riskLots=  riskAmount/(stopLossx*pointValue);else riskLots=0.3;

Print ("stoploss"  +stopLossx + "point  "+ point+  " pointvalue  "+pointValue);
return (riskLots);

}








//**
