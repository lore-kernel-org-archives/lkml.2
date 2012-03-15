Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161184Ab2COTHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:07:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50483 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762090Ab2COTG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:06:56 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 1/5] Staging: rtl8187se: r8180_dm.c: Removed spaces before tab stop
Date: Thu, 15 Mar 2012 15:05:17 -0400
Message-Id: <1331838321-18453-2-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331838321-18453-1-git-send-email-amiller@amilx.com>
References: <1331838321-18453-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up spaces before tab stops and some trailing space to.

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_dm.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index 261085d..80fd71c 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -180,7 +180,7 @@ DIG_Zebra(
 	u16			OfdmFA1, OfdmFA2;
 	int			InitialGainStep = 7; // The number of initial gain stages.
 	int			LowestGainStage = 4; // The capable lowest stage of performing dig workitem.
-	u32 			AwakePeriodIn2Sec=0;
+	u32			AwakePeriodIn2Sec=0;
 
 	//printk("---------> DIG_Zebra()\n");
 
@@ -502,7 +502,7 @@ MgntIsCckRate(
 //
 //	Description:
 //		Tx Power tracking mechanism routine on 87SE.
-// 	Created by Roger, 2007.12.11.
+//	Created by Roger, 2007.12.11.
 //
 void
 TxPwrTracking87SE(
@@ -567,11 +567,11 @@ StaRateAdaptive87SE(
 	)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	unsigned long 			CurrTxokCnt;
+	unsigned long			CurrTxokCnt;
 	u16			CurrRetryCnt;
 	u16			CurrRetryRate;
 	//u16			i,idx;
-	unsigned long       	CurrRxokCnt;
+	unsigned long		CurrRxokCnt;
 	bool			bTryUp = false;
 	bool			bTryDown = false;
 	u8			TryUpTh = 1;
@@ -579,7 +579,7 @@ StaRateAdaptive87SE(
 	u32			TxThroughput;
 	long		CurrSignalStrength;
 	bool		bUpdateInitialGain = false;
-    	u8			u1bOfdm=0, u1bCck = 0;
+	u8			u1bOfdm=0, u1bCck = 0;
 	char		OfdmTxPwrIdx, CckTxPwrIdx;
 
 	priv->RateAdaptivePeriod= RATE_ADAPTIVE_TIMER_PERIOD;
@@ -634,7 +634,7 @@ StaRateAdaptive87SE(
 		if (priv->TryupingCountNoData>30)
 		{
 			priv->TryupingCountNoData = 0;
-		 	priv->CurrentOperaRate = GetUpgradeTxRate(dev, priv->CurrentOperaRate);
+			priv->CurrentOperaRate = GetUpgradeTxRate(dev, priv->CurrentOperaRate);
 			// Reset Fail Record
 			priv->LastFailTxRate = 0;
 			priv->LastFailTxRateSS = -200;
@@ -687,9 +687,9 @@ StaRateAdaptive87SE(
 	{
 		//2 For Test Upgrading mechanism
 		// Note:
-		// 	Sometimes the throughput is upon on the capability bwtween the AP and NIC,
-		// 	thus the low data rate does not improve the performance.
-		// 	We randomly upgrade the data rate and check if the retry rate is improved.
+		//	Sometimes the throughput is upon on the capability bwtween the AP and NIC,
+		//	thus the low data rate does not improve the performance.
+		//	We randomly upgrade the data rate and check if the retry rate is improved.
 
 		// Upgrading rate did not improve the retry rate, fallback to the original rate.
 		if ( (CurrRetryRate > 25) && TxThroughput < priv->LastTxThroughput)
@@ -846,7 +846,7 @@ StaRateAdaptive87SE(
 			bTryDown = true;
 			priv->TryDownCountLowData += TryDownTh;
 		}
-  		else if ( (CurrRetryRate<20) && (priv->LastRetryRate<21)) //TO DO: need to consider (RSSI)
+		else if ( (CurrRetryRate<20) && (priv->LastRetryRate<21)) //TO DO: need to consider (RSSI)
 //		else if ( (CurrRetryRate<40) && (priv->LastRetryRate<41))
 		{
 			bTryUp = true;
@@ -942,7 +942,7 @@ StaRateAdaptive87SE(
 	}
 
 	if(bTryUp && bTryDown)
-    	printk("StaRateAdaptive87B(): Tx Rate tried upping and downing simultaneously!\n");
+	printk("StaRateAdaptive87B(): Tx Rate tried upping and downing simultaneously!\n");
 
 	//1 Test Upgrading Tx Rate
 	// Sometimes the cause of the low throughput (high retry rate) is the compatibility between the AP and NIC.
-- 
1.7.7.6

