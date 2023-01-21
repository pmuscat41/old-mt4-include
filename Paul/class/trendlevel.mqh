//+------------------------------------------------------------------+
//|                                                   trendlevel.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


enum ENUM_OFX_TREND_BREAK {
      OFX_TREND_BREAK_NONE,
      OFX_TREND_BREAK_ABOVE,
      OFX_TREND_BREAK_BELOW
      };
      
class CTrendLevel {

private:

string mLevelName;

public:
   
      CTrendLevel (string levelName)      { SetLevelName (levelName);     }
      ~CTrendLevel ()                     {   }   

   void SetLevelName (string levelName){  mLevelName= levelName;}
   string GetLevelName ()              {return (mLevelName);      }

ENUM_OFX_TREND_BREAK GetBreak (int index);


};
  

///++++++++++++++++++++++++++++++++++++++++++++++++++

ENUM_OFX_TREND_BREAK CTrendLevel:: GetBreak (int index){

if (ObjectFind(0,mLevelName)<0) return (OFX_TREND_BREAK_NONE); // NO TRENDLINE FOUND

double   prevOpen    =  iOpen (Symbol(),Period(),index+1);
double   prevClose   =  iClose (Symbol(),Period(),index+1);
double   close       =  iClose (Symbol(),Period(), index);

datetime prevTime    =  iTime(Symbol(),Period(),index+1);
datetime time        =  iTime (Symbol(),Period(),index);

double   prevValue   =  ObjectGetValueByTime (0,mLevelName,prevTime);
double   value       =  ObjectGetValueByTime (0,mLevelName, time);

if (prevValue==0 || value==0) return (OFX_TREND_BREAK_NONE);

if ( ( prevOpen<prevValue && prevClose<prevValue)
      && close>value){ 
         return (OFX_TREND_BREAK_ABOVE);}
         

if ( ( prevOpen>prevValue && prevClose>prevValue)
      && close<value){ 
         return (OFX_TREND_BREAK_BELOW);}
         
return (OFX_TREND_BREAK_NONE);
}