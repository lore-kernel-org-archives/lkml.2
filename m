Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab1IBHwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:52:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42473 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1IBHwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:52:06 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8187se: Fix whitespace issues
Date: Fri,  2 Sep 2011 00:51:53 -0700
Message-Id: <1314949913-13090-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed whitespace issues found by checkpatch.pl

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/staging/rtl8187se/r8180.h       |   12 ++++++------
 drivers/staging/rtl8187se/r8180_core.c  |   22 +++++++++++-----------
 drivers/staging/rtl8187se/r8180_dm.c    |   23 +++++++++++------------
 drivers/staging/rtl8187se/r8180_wx.c    |    4 +---
 drivers/staging/rtl8187se/r8185b_init.c |    3 +--
 5 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index a2c46ae..175aa82 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -63,7 +63,7 @@
 
 #define BEACON_QUEUE					6
 
-#define aSifsTime 	10
+#define aSifsTime	10
 
 #define sCrcLng         4
 #define sAckCtsLng	112		// bits in ACK and CTS frames
@@ -78,7 +78,7 @@ typedef enum _WIRELESS_MODE {
 	WIRELESS_MODE_AUTO = 0x08,
 } WIRELESS_MODE;
 
-typedef struct 	ChnlAccessSetting {
+typedef struct	ChnlAccessSetting {
 	u16 SIFS_Timer;
 	u16 DIFS_Timer;
 	u16 SlotTimeTimer;
@@ -216,7 +216,7 @@ typedef struct Stats
 } Stats;
 
 #define MAX_LD_SLOT_NUM 10
-#define KEEP_ALIVE_INTERVAL 				20 // in seconds.
+#define KEEP_ALIVE_INTERVAL				20 // in seconds.
 #define CHECK_FOR_HANG_PERIOD			2 //be equal to watchdog check time
 #define DEFAULT_KEEP_ALIVE_LEVEL			1
 #define DEFAULT_SLOT_NUM					2
@@ -591,14 +591,14 @@ typedef struct r8180_priv
 	int	   ForcedDataRate; // Force Data Rate. 0: Auto, 0x02: 1M ~ 0x6C: 54M.)
 	u32     NumTxUnicast; //YJ,add,080828,for keep alive
 	u8      keepAliveLevel; //YJ,add,080828,for KeepAlive
-	unsigned long 	NumTxOkTotal;
+	unsigned long	NumTxOkTotal;
 	u16                                 LastRetryCnt;
         u16                                     LastRetryRate;
         unsigned long       LastTxokCnt;
         unsigned long           LastRxokCnt;
         u16                                     CurrRetryCnt;
         unsigned long           LastTxOKBytes;
-	unsigned long 		    NumTxOkBytesTotal;
+	unsigned long		    NumTxOkBytesTotal;
         u8                          LastFailTxRate;
         long                        LastFailTxRateSS;
         u8                          FailTxRateCount;
@@ -636,7 +636,7 @@ typedef struct r8180_priv
 	u32 ReceiveConfig;
 	u32 IntrMask;
 
-	struct 	ChnlAccessSetting  ChannelAccessSetting;
+	struct	ChnlAccessSetting  ChannelAccessSetting;
 }r8180_priv;
 
 #define MANAGE_PRIORITY 0
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 4c6651a..dbcf383 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1654,7 +1654,7 @@ void rtl8180_rx(struct net_device *dev)
 			}
 			/* support for prism header has been originally added by Christian */
 			if (priv->prism_hdr && priv->ieee80211->iw_mode == IW_MODE_MONITOR) {
-				
+
 			} else {
 				priv->rx_skb = dev_alloc_skb(len+2);
 				if (!priv->rx_skb)
@@ -1766,7 +1766,7 @@ void rtl8180_data_hard_resume(struct net_device *dev)
 	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
 }
 
-/* 
+/*
  * This function TX data frames when the ieee80211 stack requires this.
  * It checks also if we need to stop the ieee tx queue, eventually do it
  */
@@ -1810,7 +1810,7 @@ rate) {
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 }
 
-/* 
+/*
  * This is a rough attempt to TX a frame
  * This is called by the ieee 80211 stack to TX management frames.
  * If the ring is full packet are dropped (for data frame the queue
@@ -1916,7 +1916,7 @@ void rtl8180_prepare_beacon(struct net_device *dev)
 	}
 }
 
-/* 
+/*
  * This function do the real dirty work: it enqueues a TX command
  * descriptor in the ring buffer, copyes the frame in a TX buffer
  * and kicks the NIC to ensure it does the DMA transfer.
@@ -2184,7 +2184,7 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 			priv->txhpbufstail = buflist;
 			break;
 		case BEACON_PRIORITY:
-			/* 
+			/*
 			 * The HW seems to be happy with the 1st
 			 * descriptor filled and the 2nd empty...
 			 * So always update descriptor 1 and never
@@ -2304,13 +2304,13 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 	spin_lock_irqsave(&priv->ps_lock, flags);
 
-	/* 
+	/*
 	 * Writing HW register with 0 equals to disable
 	 * the timer, that is not really what we want
 	 */
 	tl -= MSECS(4+16+7);
 
-	/* 
+	/*
 	 * If the interval in witch we are requested to sleep is too
 	 * short then give up and remain awake
 	 */
@@ -2328,7 +2328,7 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp); /* as tl may be less than rb */
 	}
-	/* 
+	/*
 	 * If we suspect the TimerInt is gone beyond tl
 	 * while setting it, then give up
 	 */
@@ -3168,7 +3168,7 @@ void rtl8180_adapter_start(struct net_device *dev)
 	netif_start_queue(dev);
 }
 
-/* 
+/*
  * This configures registers for beacon tx and enables it via
  * rtl8180_beacon_tx_enable(). rtl8180_beacon_tx_disable() might
  * be used to stop beacon transmission
@@ -3839,7 +3839,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 			return;
 		}
 
-	/* 
+	/*
 	 * We check all the descriptors between the head and the nic,
 	 * but not the currently pointed by the nic (the next to be txed)
 	 * and the previous of the pointed (might be in process ??)
@@ -3877,7 +3877,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 			head += 8;
 	}
 
-	/* 
+	/*
 	 * The head has been moved to the last certainly TXed
 	 * (or at least processed by the nic) packet.
 	 * The driver take forcefully owning of all these packets
diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index 261085d..5e87647 100644
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
@@ -1626,4 +1626,3 @@ SwAntennaDiversityTimerCallback(
 
 	//printk("-SwAntennaDiversityTimerCallback()\n");
 }
-
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 39ef7e0..8160aef 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -1169,7 +1169,7 @@ static int r8180_wx_set_channelplan(struct net_device *dev,
 		/* Set new channel map */
 		for (i = 1; i <= DefaultChannelPlan[*val].Len; i++)
 			GET_DOT11D_INFO(priv->ieee80211)->channel_map[DefaultChannelPlan[*val].Channel[i-1]] = 1;
-		
+
 	}
 	up(&priv->wx_sem);
 
@@ -1571,5 +1571,3 @@ struct iw_handler_def  r8180_wx_handlers_def = {
 	.get_wireless_stats = r8180_get_wireless_stats,
 	.private_args = (struct iw_priv_args *)r8180_private_args,
 };
-
-
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 4b0b830..6c0e6c2 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -172,7 +172,7 @@ if (offset == PhyAddr)	{
 		*/
 /*		NdisAcquireSpinLock( &(pDevice->IoSpinLock) );	*/
 
-		for (idx = 0; idx < 30; idx++)	{ 
+		for (idx = 0; idx < 30; idx++)	{
 		/* Make sure command bit is clear before access it.	*/
 			u1bTmp = PlatformIORead1Byte(dev, PhyAddr);
 			if ((u1bTmp & BIT7) == 0)
@@ -1765,4 +1765,3 @@ void rtl8185b_tx_enable(struct net_device *dev)
 	cmd = read_nic_byte(dev, CMD);
 	write_nic_byte(dev, CMD, cmd | (1<<CMD_TX_ENABLE_SHIFT));
 }
-
-- 
1.7.6

