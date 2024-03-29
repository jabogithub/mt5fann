//+------------------------------------------------------------------+
//|                                                        GCANN.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <GC\Oracle.mqh>
#include <GC\OracleDummy_fc.mqh>
#include <GC\CurrPairs.mqh> // ����
#include <GC\Watcher.mqh>
CWatcher          Watcher;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
                            //#include <GC\GetVectors.mqh>
//#include <GC\CommonFunctions.mqh>
class CDummy:public COracleTemplate
  {
  
public:
   virtual double    forecast(string smbl="",int shift=0,bool train=false);
   virtual string    Name(){return("iEnvelopes");};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CDummy::forecast(string smbl,int shift=0,bool train=false)
  {

   double sig=0;
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(smbl,_Period,shift,3,rates);
   datetime time=rates[0].time;
//if(debug)Print(time);
sig = 
   //return(
   od_forecast(time,smbl)
   ;//);
   return(sig);
   
   if(sig<-0.66) return(NewOrderSell);
   if(sig<-0.33) return(NewOrderWaitSell);
   if(sig<0.33) return(NewOrderWait);
   if(sig<0.66) return(NewOrderWaitBuy);
   //if(sig<1.0) 
   return(NewOrderBuy);
 
 
   
  }
//+------------------------------------------------------------------+

CDummy *MyExpert;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   MyExpert=new CDummy;
   MyExpert.debug=true;
   CPInit();
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ExportHistory("res_oracle.csv");
   delete MyExpert;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//   static double lastf=0;
   int SymbolIdx;
   double f;
   //Watcher.Run();//
   if(_TrailingPosition_) Trailing();
   if(isNewBar())
     {
      for(SymbolIdx=0; SymbolIdx<MaxSymbols;SymbolIdx++)
        {
         f=MyExpert.forecast(SymbolsArray[SymbolIdx],0,false);
         NewOrder(SymbolsArray[SymbolIdx],f,(string)f);
        }
        
     }
  }
//+------------------------------------------------------------------+
