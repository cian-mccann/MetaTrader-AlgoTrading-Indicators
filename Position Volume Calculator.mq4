#property copyright "Cian McCann"
#property link      "https://www.mql5.com"
#property version   "1.00"

int OnInit()
{     
      IndicatorShortName("Position Volume Calculator");
      ObjectCreate(0,"Stop Level",OBJ_HLINE,0,0,SymbolInfoDouble(Symbol(),SYMBOL_BID)); // Create Stop Loss line
      return(INIT_SUCCEEDED);
}

/***** Main Function *****/ 
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   double stopLossLevel = ObjectGetDouble(0,"Stop Level",OBJPROP_PRICE,0);
   // TODO: Remove indicator if stop loss line was not found or stopLossLevel is not set
   
   double differenceInPoints;
   string tradeType;
   string chartSymbol = ChartSymbol(0);
   if (stopLossLevel < Ask) {
      if (StringCompare(chartSymbol,  "USOIL(€)", false) == 0) {
         differenceInPoints = (Ask-stopLossLevel)*100;
         tradeType = "Long trade on " + chartSymbol;
      } else if (StringCompare(chartSymbol,  "SPX500(€)", false) == 0) {
         differenceInPoints = (Ask-stopLossLevel);
         tradeType = "Long trade on " + chartSymbol;
      } else if (StringCompare(chartSymbol,  "GBPUSD(€)", false) == 0) {
         differenceInPoints = (Ask-stopLossLevel)*10000;
         tradeType = "Long trade on " + chartSymbol;
      } else if (StringCompare(chartSymbol,  "GBPJPY(€)", false) == 0) {
         differenceInPoints = (Ask-stopLossLevel)*100;
         tradeType = "Long trade on " + chartSymbol;
      } else {
         Print("Closing Position Volume Calculator indicator, this chart is not supported.");
         ChartIndicatorDelete(0,0,"Position Volume Calculator");
      }
   } else {
      if (StringCompare(chartSymbol,  "USOIL(€)", false) == 0) {
         differenceInPoints = (stopLossLevel-Bid)*100;
         tradeType = "Short trade on " + chartSymbol;
      } else if (StringCompare(chartSymbol,  "SPX500(€)", false) == 0) {
         differenceInPoints = (stopLossLevel-Bid);
         tradeType = "Short trade on " + chartSymbol;
      } else if (StringCompare(chartSymbol,  "GBPUSD(€)", false) == 0) {
         differenceInPoints = (stopLossLevel-Bid)*10000;
         tradeType = "Short trade on " + chartSymbol;
      } else if (StringCompare(chartSymbol,  "GBPJPY(€)", false) == 0) {
         differenceInPoints = (stopLossLevel-Bid)*100;
         tradeType = "Short trade on " + chartSymbol;
      } else {
         Print("Closing Position Volume Calculator indicator, this chart is not supported.");
         ChartIndicatorDelete(0,0,"Position Volume Calculator");
      }
   }
   
   string differenceInPointsString= "Stop loss distance in points = " + DoubleToStr(differenceInPoints, 2);
   
   double accountBalance = AccountBalance();
   string accountBalanceString = "Account balance = " + accountBalance;
   
   //1%
   double euroAmountToRisk = accountBalance*0.01; 
   double euroPerPoint = euroAmountToRisk/differenceInPoints;
   double actualAmountToBeRisked = NormalizeDouble(euroAmountToRisk/differenceInPoints, 1) * differenceInPoints;
   string euroAmountToRiskString = "1% of account = " + euroAmountToRisk + " (" + NormalizeDouble(actualAmountToBeRisked,2) + " actual)"; 
   string euroPerPointString = "Amount per point (Volume) = " + NormalizeDouble(euroPerPoint,2) + " (" + NormalizeDouble(euroPerPoint,1) + " actual)";
      
   Comment("\n" + "Position Volume Calculator active:" + "\n\n" 
      + tradeType + "\n\n" 
         + differenceInPointsString, "\n\n", 
            accountBalanceString, "\n\n", 
               euroAmountToRiskString, ". ", euroPerPointString);

   return(rates_total);
}

void OnDeinit(const int reason)
{
   if (reason == 1) {
      ObjectDelete(0,"Stop Level");
      Comment("");
      Print("Position Volume Calculator indicator closed.");
   }
   
}
