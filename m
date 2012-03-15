Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161293Ab2COTIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:08:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44452 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161213Ab2COTHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:07:04 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 3/5] Staging: rtl8187se: r8180_dm.c Fixed indentation issues
Date: Thu, 15 Mar 2012 15:05:19 -0400
Message-Id: <1331838321-18453-4-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331838321-18453-1-git-send-email-amiller@amilx.com>
References: <1331838321-18453-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed indentation issues and converted spaces,
that were being use for indentation, to tabs

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_dm.c |  418 +++++++++++++++++-----------------
 1 files changed, 209 insertions(+), 209 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index 97e4fef..bd2cf4a 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -75,12 +75,12 @@ DoTxHighPower(
 
 		// If it never enter High Power.
 		if( CckTxPwrIdx == u1bTmp) {
-		u1bTmp = (u1bTmp > 16) ? (u1bTmp -16): 0;  // 8dbm
-		write_nic_byte(dev, CCK_TXAGC, u1bTmp);
+			u1bTmp = (u1bTmp > 16) ? (u1bTmp -16): 0;  // 8dbm
+			write_nic_byte(dev, CCK_TXAGC, u1bTmp);
 
-		u1bTmp= read_nic_byte(dev, OFDM_TXAGC);
-		u1bTmp = (u1bTmp > 16) ? (u1bTmp -16): 0;  // 8dbm
-		write_nic_byte(dev, OFDM_TXAGC, u1bTmp);
+			u1bTmp= read_nic_byte(dev, OFDM_TXAGC);
+			u1bTmp = (u1bTmp > 16) ? (u1bTmp -16): 0;  // 8dbm
+			write_nic_byte(dev, OFDM_TXAGC, u1bTmp);
 		}
 
 	} else if((priv->UndecoratedSmoothedSS < HiPwrLowerTh) &&
@@ -91,16 +91,16 @@ DoTxHighPower(
 			//SD3 required.
 			u1bTmp= read_nic_byte(dev, CCK_TXAGC);
 			if(u1bTmp < CckTxPwrIdx) {
-			//u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);  // 8dbm
-			//write_nic_byte(dev, CCK_TXAGC, u1bTmp);
-			write_nic_byte(dev, CCK_TXAGC, CckTxPwrIdx);
+				//u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);  // 8dbm
+				//write_nic_byte(dev, CCK_TXAGC, u1bTmp);
+				write_nic_byte(dev, CCK_TXAGC, CckTxPwrIdx);
 			}
 
 			u1bTmp= read_nic_byte(dev, OFDM_TXAGC);
 			if(u1bTmp < OfdmTxPwrIdx) {
-			//u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);  // 8dbm
-			//write_nic_byte(dev, OFDM_TXAGC, u1bTmp);
-			write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
+				//u1bTmp = ((u1bTmp+16) > 35) ? 35: (u1bTmp+16);  // 8dbm
+				//write_nic_byte(dev, OFDM_TXAGC, u1bTmp);
+				write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
 			}
 		}
 	}
@@ -121,8 +121,8 @@ void rtl8180_tx_pw_wq (struct work_struct *work)
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
 	struct delayed_work *dwork = to_delayed_work(work);
-        struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,tx_pw_wq);
-        struct net_device *dev = ieee->dev;
+	struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,tx_pw_wq);
+	struct net_device *dev = ieee->dev;
 
 //	printk("----> UpdateTxPowerWorkItemCallback()\n");
 
@@ -181,7 +181,7 @@ DIG_Zebra(
 //	printk("DIG**********CCK False Alarm: %#X \n",CCKFalseAlarm);
 //	printk("DIG**********OFDM False Alarm: %#X \n",OFDMFalseAlarm);
 
-        // The number of initial gain steps is different, by Bruce, 2007-04-13.
+	// The number of initial gain steps is different, by Bruce, 2007-04-13.
 	if (priv->InitialGain == 0 ) { //autoDIG
 		// Advised from SD3 DZ
 		priv->InitialGain = 4; // In 87B, m74dBm means State 4 (m82dBm)
@@ -265,8 +265,8 @@ DynamicInitGain(struct net_device *dev)
 void rtl8180_hw_dig_wq (struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-        struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_dig_wq);
-        struct net_device *dev = ieee->dev;
+	struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_dig_wq);
+	struct net_device *dev = ieee->dev;
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 	// Read CCK and OFDM False Alarm.
@@ -280,33 +280,33 @@ void rtl8180_hw_dig_wq (struct work_struct *work)
 
 int
 IncludedInSupportedRates(
-        struct r8180_priv       *priv,
-        u8              TxRate  )
+	struct r8180_priv       *priv,
+	u8              TxRate  )
 {
-    u8 rate_len;
-        u8 rate_ex_len;
-        u8                      RateMask = 0x7F;
-        u8                      idx;
-        unsigned short          Found = 0;
-        u8                      NaiveTxRate = TxRate&RateMask;
-
-    rate_len = priv->ieee80211->current_network.rates_len;
-        rate_ex_len = priv->ieee80211->current_network.rates_ex_len;
-        for( idx=0; idx< rate_len; idx++ ) {
-                if( (priv->ieee80211->current_network.rates[idx] & RateMask) == NaiveTxRate ) {
-                        Found = 1;
-                        goto found_rate;
-                }
-        }
-    for( idx=0; idx< rate_ex_len; idx++ ) {
-                if( (priv->ieee80211->current_network.rates_ex[idx] & RateMask) == NaiveTxRate ) {
-                        Found = 1;
-                        goto found_rate;
-                }
-        }
-        return Found;
-        found_rate:
-        return Found;
+	u8 rate_len;
+	u8 rate_ex_len;
+	u8                      RateMask = 0x7F;
+	u8                      idx;
+	unsigned short          Found = 0;
+	u8                      NaiveTxRate = TxRate&RateMask;
+
+	rate_len = priv->ieee80211->current_network.rates_len;
+	rate_ex_len = priv->ieee80211->current_network.rates_ex_len;
+	for( idx=0; idx< rate_len; idx++ ) {
+		if( (priv->ieee80211->current_network.rates[idx] & RateMask) == NaiveTxRate ) {
+			Found = 1;
+			goto found_rate;
+		}
+	}
+	for( idx=0; idx< rate_ex_len; idx++ ) {
+		if( (priv->ieee80211->current_network.rates_ex[idx] & RateMask) == NaiveTxRate ) {
+			Found = 1;
+			goto found_rate;
+		}
+	}
+	return Found;
+	found_rate:
+	return Found;
 }
 
 //
@@ -317,64 +317,64 @@ IncludedInSupportedRates(
 //
 u8
 GetUpgradeTxRate(
-        struct net_device *dev,
-        u8                              rate
-        )
+	struct net_device *dev,
+	u8                              rate
+	)
 {
-        struct r8180_priv *priv = ieee80211_priv(dev);
-        u8                      UpRate;
-
-        // Upgrade 1 degree.
-        switch(rate) {
-        case 108: // Up to 54Mbps.
-                UpRate = 108;
-                break;
-
-        case 96: // Up to 54Mbps.
-                UpRate = 108;
-                break;
-
-        case 72: // Up to 48Mbps.
-                UpRate = 96;
-                break;
-
-        case 48: // Up to 36Mbps.
-                UpRate = 72;
-                break;
-
-        case 36: // Up to 24Mbps.
-                UpRate = 48;
-                break;
-
-        case 22: // Up to 18Mbps.
-                UpRate = 36;
-                break;
-
-        case 11: // Up to 11Mbps.
-                UpRate = 22;
-                break;
-
-        case 4: // Up to 5.5Mbps.
-                UpRate = 11;
-                break;
-
-        case 2: // Up to 2Mbps.
-                UpRate = 4;
-                break;
-
-        default:
-                printk("GetUpgradeTxRate(): Input Tx Rate(%d) is undefined!\n", rate);
-                return rate;
-        }
-        // Check if the rate is valid.
-        if(IncludedInSupportedRates(priv, UpRate)) {
+	struct r8180_priv *priv = ieee80211_priv(dev);
+	u8                      UpRate;
+
+	// Upgrade 1 degree.
+	switch(rate) {
+	case 108: // Up to 54Mbps.
+		UpRate = 108;
+		break;
+
+	case 96: // Up to 54Mbps.
+		UpRate = 108;
+		break;
+
+	case 72: // Up to 48Mbps.
+		UpRate = 96;
+		break;
+
+	case 48: // Up to 36Mbps.
+		UpRate = 72;
+		break;
+
+	case 36: // Up to 24Mbps.
+		UpRate = 48;
+		break;
+
+	case 22: // Up to 18Mbps.
+		UpRate = 36;
+		break;
+
+	case 11: // Up to 11Mbps.
+		UpRate = 22;
+		break;
+
+	case 4: // Up to 5.5Mbps.
+		UpRate = 11;
+		break;
+
+	case 2: // Up to 2Mbps.
+		UpRate = 4;
+		break;
+
+	default:
+		printk("GetUpgradeTxRate(): Input Tx Rate(%d) is undefined!\n", rate);
+		return rate;
+	}
+	// Check if the rate is valid.
+	if(IncludedInSupportedRates(priv, UpRate)) {
 //              printk("GetUpgradeTxRate(): GetUpgrade Tx rate(%d) from %d !\n", UpRate, priv->CurrentOperaRate);
-                return UpRate;
-        } else {
-                //printk("GetUpgradeTxRate(): Tx rate (%d) is not in supported rates\n", UpRate);
-                return rate;
-        }
-        return rate;
+		return UpRate;
+	} else {
+		//printk("GetUpgradeTxRate(): Tx rate (%d) is not in supported rates\n", UpRate);
+		return rate;
+	}
+	return rate;
 }
 //
 //      Description:
@@ -384,64 +384,64 @@ GetUpgradeTxRate(
 //
 u8
 GetDegradeTxRate(
-        struct net_device *dev,
-        u8         rate
-        )
+	struct net_device *dev,
+	u8         rate
+	)
 {
-        struct r8180_priv *priv = ieee80211_priv(dev);
-        u8                      DownRate;
-
-        // Upgrade 1 degree.
-        switch(rate) {
-        case 108: // Down to 48Mbps.
-                DownRate = 96;
-                break;
-
-        case 96: // Down to 36Mbps.
-                DownRate = 72;
-                break;
-
-        case 72: // Down to 24Mbps.
-                DownRate = 48;
-                break;
-
-        case 48: // Down to 18Mbps.
-                DownRate = 36;
-                break;
-
-        case 36: // Down to 11Mbps.
-                DownRate = 22;
-                break;
-
-        case 22: // Down to 5.5Mbps.
-                DownRate = 11;
-                break;
-
-        case 11: // Down to 2Mbps.
-                DownRate = 4;
-                break;
-
-        case 4: // Down to 1Mbps.
-                DownRate = 2;
-                break;
-
-        case 2: // Down to 1Mbps.
-                DownRate = 2;
-                break;
-
-        default:
-                printk("GetDegradeTxRate(): Input Tx Rate(%d) is undefined!\n", rate);
-                return rate;
-        }
-        // Check if the rate is valid.
-        if(IncludedInSupportedRates(priv, DownRate)) {
+	struct r8180_priv *priv = ieee80211_priv(dev);
+	u8                      DownRate;
+
+	// Upgrade 1 degree.
+	switch(rate) {
+	case 108: // Down to 48Mbps.
+		DownRate = 96;
+		break;
+
+	case 96: // Down to 36Mbps.
+		DownRate = 72;
+		break;
+
+	case 72: // Down to 24Mbps.
+		DownRate = 48;
+		break;
+
+	case 48: // Down to 18Mbps.
+		DownRate = 36;
+		break;
+
+	case 36: // Down to 11Mbps.
+		DownRate = 22;
+		break;
+
+	case 22: // Down to 5.5Mbps.
+		DownRate = 11;
+		break;
+
+	case 11: // Down to 2Mbps.
+		DownRate = 4;
+		break;
+
+	case 4: // Down to 1Mbps.
+		DownRate = 2;
+		break;
+
+	case 2: // Down to 1Mbps.
+		DownRate = 2;
+		break;
+
+	default:
+		printk("GetDegradeTxRate(): Input Tx Rate(%d) is undefined!\n", rate);
+		return rate;
+	}
+	// Check if the rate is valid.
+	if(IncludedInSupportedRates(priv, DownRate)) {
 //              printk("GetDegradeTxRate(): GetDegrade Tx rate(%d) from %d!\n", DownRate, priv->CurrentOperaRate);
-                return DownRate;
-        } else {
-                //printk("GetDegradeTxRate(): Tx rate (%d) is not in supported rates\n", DownRate);
-                return rate;
-        }
-        return rate;
+		return DownRate;
+	} else {
+		//printk("GetDegradeTxRate(): Tx rate (%d) is not in supported rates\n", DownRate);
+		return rate;
+	}
+	return rate;
 }
 //
 //      Helper function to determine if specified data rate is
@@ -450,16 +450,16 @@ GetDegradeTxRate(
 //
 bool
 MgntIsCckRate(
-        u16     rate
-        )
+	u16     rate
+	)
 {
-        bool bReturn = false;
+	bool bReturn = false;
 
-        if((rate <= 22) && (rate != 12) && (rate != 18)) {
-                bReturn = true;
-        }
+	if((rate <= 22) && (rate != 12) && (rate != 18)) {
+		bReturn = true;
+	}
 
-        return bReturn;
+	return bReturn;
 }
 //
 //	Description:
@@ -490,7 +490,7 @@ TxPwrTracking87SE(
 			CckTxPwrIdx = priv->chtxpwr[Idx];
 			OfdmTxPwrIdx = priv->chtxpwr_ofdm[Idx];
 
-			if( CurrentThermal > priv->ThermalMeter ) { 
+			if( CurrentThermal > priv->ThermalMeter ) {
 				// higher thermal meter.
 				CckTxPwrIdx += (CurrentThermal - priv->ThermalMeter)*2;
 				OfdmTxPwrIdx += (CurrentThermal - priv->ThermalMeter)*2;
@@ -526,19 +526,19 @@ StaRateAdaptive87SE(
 	)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	unsigned long			CurrTxokCnt;
-	u16			CurrRetryCnt;
-	u16			CurrRetryRate;
-	//u16			i,idx;
-	unsigned long		CurrRxokCnt;
-	bool			bTryUp = false;
-	bool			bTryDown = false;
-	u8			TryUpTh = 1;
-	u8			TryDownTh = 2;
-	u32			TxThroughput;
+	unsigned long	CurrTxokCnt;
+	u16		CurrRetryCnt;
+	u16		CurrRetryRate;
+	//u16		i,idx;
+	unsigned long	CurrRxokCnt;
+	bool		bTryUp = false;
+	bool		bTryDown = false;
+	u8		TryUpTh = 1;
+	u8		TryDownTh = 2;
+	u32		TxThroughput;
 	long		CurrSignalStrength;
 	bool		bUpdateInitialGain = false;
-	u8			u1bOfdm=0, u1bCck = 0;
+	u8		u1bOfdm=0, u1bCck = 0;
 	char		OfdmTxPwrIdx, CckTxPwrIdx;
 
 	priv->RateAdaptivePeriod= RATE_ADAPTIVE_TIMER_PERIOD;
@@ -629,7 +629,7 @@ StaRateAdaptive87SE(
 	// Let these rates down more difficult.
 	//
 	if(MgntIsCckRate(priv->CurrentOperaRate) || priv->CurrentOperaRate == 36)
-			TryDownTh += 1;
+		TryDownTh += 1;
 
 	//1 Adjust Rate.
 	if (priv->bTryuping == true) {
@@ -701,7 +701,7 @@ StaRateAdaptive87SE(
 //		if ( ((CurrRetryRate>65) && (priv->LastRetryRate>64)))
 			//Down to rate 36Mbps.
 			bTryDown = true;
-		} else if ( ((CurrRetryRate>21) && (priv->LastRetryRate>20)) && (CurrSignalStrength > -74)) { //Cable Link	
+		} else if ( ((CurrRetryRate>21) && (priv->LastRetryRate>20)) && (CurrSignalStrength > -74)) { //Cable Link
 			//Down to rate 36Mbps.
 			bTryDown = true;
 		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
@@ -771,7 +771,7 @@ StaRateAdaptive87SE(
 			bTryDown = true;
 
 		  //[TRC Dell Lab]  Isaiah 2008-02-18 23:24
-		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) { 
+		} else if((CurrRetryRate>  (priv->LastRetryRate + 50 )) && (priv->FailTxRateCount >2 )) {
 //		else if((CurrRetryRate>  (priv->LastRetryRate + 70 )) && (priv->FailTxRateCount >2 ))
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
@@ -993,9 +993,9 @@ StaRateAdaptive87SE(
 
 		// case 1: Never enter High power
 		if(u1bCck == CckTxPwrIdx ) {
-		priv->bEnhanceTxPwr= false;
-		write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
-		//printk("Recover OFDM_TXAGC : ===== u1bOfdm= 0x%x\n", OfdmTxPwrIdx);
+			priv->bEnhanceTxPwr= false;
+			write_nic_byte(dev, OFDM_TXAGC, OfdmTxPwrIdx);
+			//printk("Recover OFDM_TXAGC : ===== u1bOfdm= 0x%x\n", OfdmTxPwrIdx);
 		}
 		// case 2: enter high power
 		else if(u1bCck < CckTxPwrIdx) {
@@ -1024,7 +1024,7 @@ SetInitialGain:
 				else if(priv->InitialGain > priv->RegBModeGainStage + 1)
 					priv->InitialGain -= 2;
 
-				else 
+				else
 					priv->InitialGain --;
 
 				printk("StaRateAdaptive87SE(): update init_gain to index %d for date rate %d\n",priv->InitialGain, priv->CurrentOperaRate);
@@ -1050,11 +1050,11 @@ SetInitialGain:
 void rtl8180_rate_adapter(struct work_struct * work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-        struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,rate_adapter_wq);
-        struct net_device *dev = ieee->dev;
-        //struct r8180_priv *priv = ieee80211_priv(dev);
+	struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,rate_adapter_wq);
+	struct net_device *dev = ieee->dev;
+	//struct r8180_priv *priv = ieee80211_priv(dev);
 //    DMESG("---->rtl8180_rate_adapter");
-        StaRateAdaptive87SE(dev);
+	StaRateAdaptive87SE(dev);
 //   DMESG("<----rtl8180_rate_adapter");
 }
 void timer_rate_adaptive(unsigned long data)
@@ -1165,12 +1165,12 @@ SwitchAntenna(
 	bool		bResult;
 
 	if(priv->CurrAntennaIndex == 0) {
-			bResult = SetAntenna8185(dev, 1);
+		bResult = SetAntenna8185(dev, 1);
 //by amy 080312
 //		printk("SwitchAntenna(): switching to antenna 1 ......\n");
 //		bResult = SetAntenna8185(dev, 1);//-by amy 080312
 	} else {
-			bResult = SetAntenna8185(dev, 0);
+		bResult = SetAntenna8185(dev, 0);
 //by amy 080312
 //		printk("SwitchAntenna(): switching to antenna 0 ......\n");
 //		bResult = SetAntenna8185(dev, 0);//-by amy 080312
@@ -1246,7 +1246,7 @@ SwAntennaDiversity(
 
 			// Wrong deceision => switch back.
 			SwitchAntenna(dev);
-		} else { 
+		} else {
 		// Rx Signal Strength is improved.
 //			printk("SwAntennaDiversity(): Rx Signal Strength is improved, CurrRxSs: %d, LastRxSs: %d\n",
 //				priv->AdRxSignalStrength, priv->AdRxSsBeforeSwitched);
@@ -1319,35 +1319,35 @@ SwAntennaDiversity(
 		//
 		if( (!priv->bHWAdSwitched) && (bSwCheckSS)) {
 //by amy 080312}
-		// Evaluate Rx signal strength if we shall switch antenna now.
-		if(priv->AdRxSignalStrength < priv->AdRxSsThreshold) {
-		// Rx signal strength is weak => Switch Antenna.
-//			printk("SwAntennaDiversity(): Rx Signal Strength is weak, CurrRxSs: %d, RxSsThreshold: %d\n",
+			// Evaluate Rx signal strength if we shall switch antenna now.
+			if(priv->AdRxSignalStrength < priv->AdRxSsThreshold) {
+			// Rx signal strength is weak => Switch Antenna.
+//				printk("SwAntennaDiversity(): Rx Signal Strength is weak, CurrRxSs: %d, RxSsThreshold: %d\n",
 //				priv->AdRxSignalStrength, priv->AdRxSsThreshold);
 
-			priv->AdRxSsBeforeSwitched = priv->AdRxSignalStrength;
-			priv->bAdSwitchedChecking = true;
+				priv->AdRxSsBeforeSwitched = priv->AdRxSignalStrength;
+				priv->bAdSwitchedChecking = true;
 
-			SwitchAntenna(dev);
-		} else {
-		// Rx signal strength is OK.
-//			printk("SwAntennaDiversity(): Rx Signal Strength is OK, CurrRxSs: %d, RxSsThreshold: %d\n",
+				SwitchAntenna(dev);
+			} else {
+			// Rx signal strength is OK.
+//				printk("SwAntennaDiversity(): Rx Signal Strength is OK, CurrRxSs: %d, RxSsThreshold: %d\n",
 //				priv->AdRxSignalStrength, priv->AdRxSsThreshold);
 
-			priv->bAdSwitchedChecking = false;
-			// Increase Rx signal strength threshold if necessary.
-			if(	(priv->AdRxSignalStrength > (priv->AdRxSsThreshold + 10)) && // Signal is much stronger than current threshold
-				priv->AdRxSsThreshold <= priv->AdMaxRxSsThreshold) { // Current threhold is not yet reach upper limit.
+				priv->bAdSwitchedChecking = false;
+				// Increase Rx signal strength threshold if necessary.
+				if(	(priv->AdRxSignalStrength > (priv->AdRxSsThreshold + 10)) && // Signal is much stronger than current threshold
+					priv->AdRxSsThreshold <= priv->AdMaxRxSsThreshold) { // Current threhold is not yet reach upper limit.
 
-				priv->AdRxSsThreshold = (priv->AdRxSsThreshold + priv->AdRxSignalStrength) / 2;
-				priv->AdRxSsThreshold = (priv->AdRxSsThreshold > priv->AdMaxRxSsThreshold) ?
-												priv->AdMaxRxSsThreshold: priv->AdRxSsThreshold;//+by amy 080312
-			}
+					priv->AdRxSsThreshold = (priv->AdRxSsThreshold + priv->AdRxSignalStrength) / 2;
+					priv->AdRxSsThreshold = (priv->AdRxSsThreshold > priv->AdMaxRxSsThreshold) ?
+								priv->AdMaxRxSsThreshold: priv->AdRxSsThreshold;//+by amy 080312
+				}
 
-			// Reduce Antenna Diversity checking period if possible.
-			if( priv->AdCheckPeriod > priv->AdMinCheckPeriod )
-				priv->AdCheckPeriod /= 2;
-		}
+				// Reduce Antenna Diversity checking period if possible.
+				if( priv->AdCheckPeriod > priv->AdMinCheckPeriod )
+					priv->AdCheckPeriod /= 2;
+			}
 		}
 	}
 //by amy 080312
-- 
1.7.7.6

