Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab0FEONf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:13:35 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:9509 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933494Ab0FEOMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:12:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAA74CUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAXjTGFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="82293898"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 13/13] staging: rtl8192u: remove all C99 style comments from file r8192U_core This patch removes all C99 comments from file rtl8192U_core.c
Date: Sat,  5 Jun 2010 22:12:37 +0800
Message-Id: <1275747158-31375-14-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275747158-31375-13-git-send-email-mike.kernel@gilksonline.com>
References: <1275747158-31375-1-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-2-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-3-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-4-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-5-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-6-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-7-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-8-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-9-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-10-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-11-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-12-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-13-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  395 +++++++++++++++++---------------
 1 files changed, 214 insertions(+), 181 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 895f748..dc4d2b6 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -80,7 +80,7 @@ double __extendsfdf2(float a) {return a; }
 #ifdef ENABLE_DOT11D
 #include "dot11d.h"
 #endif
-/* set here to open your trace code. //WB */
+/* set here to open your trace code. WB */
 u32 rt_global_debug_component =
 				/*COMP_INIT		|
 				 *COMP_DBG		|
@@ -196,7 +196,7 @@ static CHANNEL_LIST ChannelPlan[] = {
 					56, 60, 64}, 22},	/* MIC */
 	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14}
 		/* For Global Domain. 1-11:active scan, 12-14 passive scan.
-		 * //+YJ, 080626
+		 * +YJ, 080626
 		 */
 };
 
@@ -2785,15 +2785,15 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 		IEEE_SOFTMAC_ASSOCIATE | IEEE_SOFTMAC_PROBERQ |
 		IEEE_SOFTMAC_PROBERS | IEEE_SOFTMAC_TX_QUEUE |
 		IEEE_SOFTMAC_BEACONS;
-		/* added by amy 080604 //|  //IEEE_SOFTMAC_SINGLE_QUEUE; */
+		/* added by amy 080604 | IEEE_SOFTMAC_SINGLE_QUEUE; */
 	priv->ieee80211->active_scan = 1;
 	priv->ieee80211->modulation = IEEE80211_CCK_MODULATION | IEEE80211_OFDM_MODULATION;
 	priv->ieee80211->host_encrypt = 1;
 	priv->ieee80211->host_decrypt = 1;
 	priv->ieee80211->start_send_beacons = NULL;
-	/* rtl819xusb_beacon_tx;//-by amy 080604 */
+	/* rtl819xusb_beacon_tx;	-by amy 080604 */
 	priv->ieee80211->stop_send_beacons = NULL;
-	/* rtl8192_beacon_stop;//-by amy 080604 */
+	/* rtl8192_beacon_stop;		-by amy 080604 */
 	priv->ieee80211->softmac_hard_start_xmit = rtl8192_hard_start_xmit;
 	priv->ieee80211->set_chan = rtl8192_set_chan;
 	priv->ieee80211->link_change = rtl8192_link_change;
@@ -2882,7 +2882,7 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 		 * 2005.07.07, by rcnjko.
 		 */
 		RCR_AB | RCR_AM | RCR_APM |	/* accept BC/MC/UC */
-		/* RCR_AICV | RCR_ACRC32 | 	//accept ICV/CRC error packet */
+		/* RCR_AICV | RCR_ACRC32 | 	accept ICV/CRC error packet */
 		((u32)7<<RCR_MXDMA_OFFSET)|
 		/* Max DMA Burst Size per Rx DMA Burst, 7: unlimited. */
 		(priv->EarlyRxThreshold<<RX_FIFO_THRESHOLD_SHIFT) |
@@ -4387,7 +4387,7 @@ int rtl8192_down(struct net_device *dev)
 	/* as cancel_delayed_work will del work->timer, so if work is not
 	 * defined as struct delayed_work, it will corrupt
 	 */
-	/* flush_scheduled_work();	evvl */
+	/* flush_scheduled_work(); */
 	rtl8192_cancel_deferred_work(priv);
 	deinit_hal_dm(dev);
 	del_timer_sync(&priv->watch_dog_timer);
@@ -4687,7 +4687,7 @@ void UpdateRxPktTimeStamp8190 (struct net_device *dev, struct ieee80211_rx_stats
 
 long rtl819x_translate_todbm(u8 signal_strength_index	)/* 0-100 index. */
 {
-	long	signal_power; // in dBm.
+	long	signal_power; /* in dBm. */
 
 	/* Translate to dBm (x=0.5y-95). */
 	signal_power = (long)((signal_strength_index + 1) >> 1);
@@ -5073,7 +5073,8 @@ static void rtl8192_query_rxphystatus(
 	memset(precord_stats, 0, sizeof(struct ieee80211_rx_stats));
 	pstats->bPacketMatchBSSID = precord_stats->bPacketMatchBSSID = bpacket_match_bssid;
 	pstats->bPacketToSelf = precord_stats->bPacketToSelf = bpacket_toself;
-	pstats->bIsCCK = precord_stats->bIsCCK = is_cck_rate;//RX_HAL_IS_CCK_RATE(pDrvInfo);
+	pstats->bIsCCK = precord_stats->bIsCCK = is_cck_rate;
+					/* RX_HAL_IS_CCK_RATE(pDrvInfo); */
 	pstats->bPacketBeacon = precord_stats->bPacketBeacon = bPacketBeacon;
 	pstats->bToSelfBA = precord_stats->bToSelfBA = bToSelfBA;
 
@@ -5093,14 +5094,11 @@ static void rtl8192_query_rxphystatus(
 
 	if(is_cck_rate)
 	{
-		//
-		// (1)Hardware does not provide RSSI for CCK
-		//
+		/* (1)Hardware does not provide RSSI for CCK */
 
-		//
-		// (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive)
-		//
-		u8 report;//, cck_agc_rpt;
+		/* (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive) */
+
+		u8 report;		/* , cck_agc_rpt; */
 
 		priv->stats.numqry_phystatusCCK++;
 
@@ -5110,9 +5108,10 @@ static void rtl8192_query_rxphystatus(
 			report = report>>6;
 			switch(report)
 			{
-				//Fixed by Jacken from Bryant 2008-03-20
-				//Original value is -38 , -26 , -14 , -2
-				//Fixed value is -35 , -23 , -11 , 6
+				/* Fixed by Jacken from Bryant 2008-03-20
+				 * Original value is -38 , -26 , -14 , -2
+				 * Fixed value is -35 , -23 , -11 , 6
+				 */
 				case 0x3:
 					rx_pwr_all = -35 - (pcck_buf->cck_agc_rpt & 0x3e);
 					break;
@@ -5152,10 +5151,9 @@ static void rtl8192_query_rxphystatus(
 		pstats->RxPWDBAll = precord_stats->RxPWDBAll = pwdb_all;
 		pstats->RecvSignalPower = pwdb_all;
 
-		//
-		// (3) Get Signal Quality (EVM)
-		//
-		//if(bpacket_match_bssid)
+		/* (3) Get Signal Quality (EVM) */
+
+		/* if(bpacket_match_bssid) */
 		{
 			u8	sq;
 
@@ -5181,12 +5179,12 @@ static void rtl8192_query_rxphystatus(
 	else
 	{
 		priv->stats.numqry_phystatusHT++;
-		//
-		// (1)Get RSSI for HT rate
-		//
+
+		/* (1)Get RSSI for HT rate */
+
 		for(i=RF90_PATH_A; i<priv->NumTotalRFPath; i++)
 		{
-			// 2008/01/30 MH we will judge RF RX path now.
+			/* 2008/01/30 MH we will judge RF RX path now. */
 			if (priv->brfpath_rxenable[i])
 				rf_rx_num++;
 			else
@@ -5195,14 +5193,14 @@ static void rtl8192_query_rxphystatus(
 		if (!rtl8192_phy_CheckIsLegalRFPath(priv->ieee80211->dev, i))
 				continue;
 
-			//Fixed by Jacken from Bryant 2008-03-20
-			//Original value is 106
+			/* Fixed by Jacken from Bryant 2008-03-20 */
+			/* Original value is 106 */
 			rx_pwr[i] = ((pofdm_buf->trsw_gain_X[i]&0x3F)*2) - 106;
 
-			//Get Rx snr value in DB
+			/* Get Rx snr value in DB */
 			tmp_rxsnr =	pofdm_buf->rxsnr_X[i];
 			rx_snrX = (char)(tmp_rxsnr);
-			//rx_snrX >>= 1;;
+			/* rx_snrX >>= 1;; */
 			rx_snrX /= 2;
 			priv->stats.rxSNRdB[i] = (long)rx_snrX;
 
@@ -5211,48 +5209,52 @@ static void rtl8192_query_rxphystatus(
 			total_rssi += RSSI;
 
 			/* Record Signal Strength for next packet */
-			//if(bpacket_match_bssid)
+			/* if(bpacket_match_bssid) */
 			{
 				pstats->RxMIMOSignalStrength[i] =(u8) RSSI;
 				precord_stats->RxMIMOSignalStrength[i] =(u8) RSSI;
 			}
 		}
 
+		/* (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive) */
 
-		//
-		// (2)PWDB, Average PWDB cacluated by hardware (for rate adaptive)
-		//
-		//Fixed by Jacken from Bryant 2008-03-20
-		//Original value is 106
+		/* Fixed by Jacken from Bryant 2008-03-20 */
+		/* Original value is 106 */
 		rx_pwr_all = (((pofdm_buf->pwdb_all ) >> 1 )& 0x7f) -106;
 		pwdb_all = rtl819x_query_rxpwrpercentage(rx_pwr_all);
 
 		pstats->RxPWDBAll = precord_stats->RxPWDBAll = pwdb_all;
 		pstats->RxPower = precord_stats->RxPower =  rx_pwr_all;
 
-		//
-		// (3)EVM of HT rate
-		//
+		/* (3)EVM of HT rate */
+
 		if(pdrvinfo->RxHT && pdrvinfo->RxRate>=DESC90_RATEMCS8 &&
 			pdrvinfo->RxRate<=DESC90_RATEMCS15)
-			max_spatial_stream = 2; //both spatial stream make sense
+			max_spatial_stream = 2;
+			/* both spatial stream make sense */
 		else
-			max_spatial_stream = 1; //only spatial stream 1 makes sense
+			max_spatial_stream = 1;
+			/* only spatial stream 1 makes sense */
 
-		for(i=0; i<max_spatial_stream; i++)
-		{
+		for (i = 0; i < max_spatial_stream; i++) {
 			tmp_rxevm =	pofdm_buf->rxevm_X[i];
 			rx_evmX = (char)(tmp_rxevm);
 
-			// Do not use shift operation like "rx_evmX >>= 1" because the compilor of free build environment
-			// fill most significant bit to "zero" when doing shifting operation which may change a negative
-			// value to positive one, then the dbm value (which is supposed to be negative)  is not correct anymore.
-			rx_evmX /= 2;	//dbm
+			/* Do not use shift operation like "rx_evmX >>= 1"
+			 * because the compilor of free build environment fill
+			 * most significant bit to "zero" when doing shifting
+			 * operation which may change a negative value to
+			 * positive one, then the dbm value (which is supposed
+			 * to be negative)  is not correct anymore.
+			 */
+			rx_evmX /= 2;		/* dbm */
 
 			evm = rtl819x_evm_dbtopercentage(rx_evmX);
-			//if(bpacket_match_bssid)
+			/* if(bpacket_match_bssid) */
 			{
-				if(i==0) // Fill value in RFD, Get the first spatial stream only
+				if(i==0)
+					/*  Fill value in RFD,
+					 * Get the first spatial stream only */
 					pstats->SignalQuality = precord_stats->SignalQuality = (u8)(evm & 0xff);
 				pstats->RxMIMOSignalQuality[i] = precord_stats->RxMIMOSignalQuality[i] = (u8)(evm & 0xff);
 			}
@@ -5262,23 +5264,30 @@ static void rtl8192_query_rxphystatus(
 		/* record rx statistics for debug */
 		rxsc_sgien_exflg = pofdm_buf->rxsc_sgien_exflg;
 		prxsc =	(phy_ofdm_rx_status_rxsc_sgien_exintfflag *)&rxsc_sgien_exflg;
-		if(pdrvinfo->BW)	//40M channel
+		if(pdrvinfo->BW)		/* 40M channel */
 			priv->stats.received_bwtype[1+prxsc->rxsc]++;
-		else				//20M channel
+		else				/* 20M channel */
 			priv->stats.received_bwtype[0]++;
 	}
 
-	//UI BSS List signal strength(in percentage), make it good looking, from 0~100.
-	//It is assigned to the BSS List in GetValueFromBeaconOrProbeRsp().
+	/* UI BSS List signal strength(in percentage), make it good looking,
+	 * from 0~100. It is assigned to the BSS List in
+	 * GetValueFromBeaconOrProbeRsp().
+	 */
 	if(is_cck_rate)
 	{
-		pstats->SignalStrength = precord_stats->SignalStrength = (u8)(rtl819x_signal_scale_mapping((long)pwdb_all));//PWDB_ALL;
+		pstats->SignalStrength = precord_stats->SignalStrength = (u8)(rtl819x_signal_scale_mapping((long)pwdb_all));
+		/* PWDB_ALL; */
 
 	}
 	else
 	{
-		//pRfd->Status.SignalStrength = pRecordRfd->Status.SignalStrength = (u8)(SignalScaleMapping(total_rssi/=RF90_PATH_MAX));//(u8)(total_rssi/=RF90_PATH_MAX);
-		// We can judge RX path number now.
+		/* pRfd->Status.SignalStrength =
+		 * pRecordRfd->Status.SignalStrength =
+		 * (u8)(SignalScaleMapping(total_rssi/=RF90_PATH_MAX));
+		 *(u8)(total_rssi/=RF90_PATH_MAX);
+		 * We can judge RX path number now.
+		 */
 		if (rf_rx_num != 0)
 			pstats->SignalStrength = precord_stats->SignalStrength = (u8)(rtl819x_signal_scale_mapping((long)(total_rssi/=rf_rx_num)));
 	}
@@ -5300,24 +5309,26 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 				   struct ieee80211_rx_stats * pstats,
 				   rx_drvinfo_819x_usb  *pdrvinfo)
 {
-	// TODO: We must only check packet for current MAC address. Not finish
+	/* TODO: We must only check packet for current MAC address.
+	 * Not finish */
 	rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
 	struct net_device *dev=info->dev;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	bool bpacket_match_bssid, bpacket_toself;
 	bool bPacketBeacon=FALSE, bToSelfBA=FALSE;
 	static struct ieee80211_rx_stats  previous_stats;
-	struct ieee80211_hdr_3addr *hdr;//by amy
-       u16 fc,type;
+	struct ieee80211_hdr_3addr *hdr;	/* by amy */
+	u16 fc,type;
 
-	// Get Signal Quality for only RX data queue (but not command queue)
+	/* Get Signal Quality for only RX data queue (but not command queue) */
 
 	u8* tmp_buf;
-	//u16 tmp_buf_len = 0;
+	/* u16 tmp_buf_len = 0; */
 	u8  *praddr;
 
 	/* Get MAC frame start address. */
-	tmp_buf = (u8*)skb->data;// + get_rxpacket_shiftbytes_819xusb(pstats);
+	tmp_buf = (u8*)skb->data;
+	/* + get_rxpacket_shiftbytes_819xusb(pstats); */
 
 	hdr = (struct ieee80211_hdr_3addr *)tmp_buf;
 	fc = le16_to_cpu(hdr->frame_ctl);
@@ -5333,29 +5344,29 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 		if(WLAN_FC_GET_FRAMETYPE(fc)== IEEE80211_STYPE_BEACON)
 		{
 			bPacketBeacon = true;
-			//DbgPrint("Beacon 2, MatchBSSID = %d, ToSelf = %d \n", bPacketMatchBSSID, bPacketToSelf);
+			/* DbgPrint("Beacon 2, MatchBSSID = %d, ToSelf = %d \n"
+			 *		, bPacketMatchBSSID, bPacketToSelf); */
 		}
 		if(WLAN_FC_GET_FRAMETYPE(fc) == IEEE80211_STYPE_BLOCKACK)
 		{
 			if((eqMacAddr(praddr,dev->dev_addr)))
 				bToSelfBA = true;
-				//DbgPrint("BlockAck, MatchBSSID = %d, ToSelf = %d \n", bPacketMatchBSSID, bPacketToSelf);
+				/* DbgPrint("BlockAck, MatchBSSID = %d,
+				 *	 ToSelf = %d \n", bPacketMatchBSSID,
+				 *	 bPacketToSelf);
+				 */
 		}
 
-
-
 	if(bpacket_match_bssid)
-	{
 		priv->stats.numpacket_matchbssid++;
-	}
 	if(bpacket_toself){
 		priv->stats.numpacket_toself++;
 	}
-	//
-	// Process PHY information for previous packet (RSSI/PWDB/EVM)
-	//
-	// Because phy information is contained in the last packet of AMPDU only, so driver
-	// should process phy information of previous packet
+
+	/* Process PHY information for previous packet (RSSI/PWDB/EVM)
+	 * Because phy information is contained in the last packet of AMPDU
+	 * only, so driver should process phy information of previous packet
+	 */
 	rtl8192_process_phyinfo(priv, tmp_buf, &previous_stats, pstats);
 	rtl8192_query_rxphystatus(priv, pstats, pdrvinfo, &previous_stats, bpacket_match_bssid,bpacket_toself,bPacketBeacon,bToSelfBA);
 	rtl8192_record_rxdesc_forlateruse(pstats, &previous_stats);
@@ -5383,9 +5394,10 @@ UpdateReceivedRateHistogramStatistics8190(
 	)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-	u32 rcvType=1;   //0: Total, 1:OK, 2:CRC, 3:ICV
+	u32 rcvType=1;   /* 0: Total, 1:OK, 2:CRC, 3:ICV */
 	u32 rateIndex;
-	u32 preamble_guardinterval;  //1: short preamble/GI, 0: long preamble/GI
+	u32 preamble_guardinterval;
+	/* 1: short preamble/GI, 0: long preamble/GI */
 
 
 	if(stats->bCRC)
@@ -5394,22 +5406,18 @@ UpdateReceivedRateHistogramStatistics8190(
 	rcvType = 3;
 
 	if(stats->bShortPreamble)
-	preamble_guardinterval = 1;// short
+	preamble_guardinterval = 1;		/* short */
 	else
-	preamble_guardinterval = 0;// long
+	preamble_guardinterval = 0;		/* long */
 
 	switch(stats->rate)
 	{
-		//
-		// CCK rate
-		//
+		/* CCK rate */
 		case MGN_1M:    rateIndex = 0;  break;
 		case MGN_2M:    rateIndex = 1;  break;
 		case MGN_5_5M:  rateIndex = 2;  break;
 		case MGN_11M:   rateIndex = 3;  break;
-		//
-		// Legacy OFDM rate
-		//
+		/* Legacy OFDM rate */
 		case MGN_6M:    rateIndex = 4;  break;
 		case MGN_9M:    rateIndex = 5;  break;
 		case MGN_12M:   rateIndex = 6;  break;
@@ -5418,9 +5426,7 @@ UpdateReceivedRateHistogramStatistics8190(
 		case MGN_36M:   rateIndex = 9;  break;
 		case MGN_48M:   rateIndex = 10; break;
 		case MGN_54M:   rateIndex = 11; break;
-		//
-		// 11n High throughput rate
-		//
+		/* 11n High throughput rate */
 		case MGN_MCS0:  rateIndex = 12; break;
 		case MGN_MCS1:  rateIndex = 13; break;
 		case MGN_MCS2:  rateIndex = 14; break;
@@ -5440,7 +5446,7 @@ UpdateReceivedRateHistogramStatistics8190(
 		default:        rateIndex = 28; break;
 	}
     priv->stats.received_preamble_GI[preamble_guardinterval][rateIndex]++;
-    priv->stats.received_rate_histogram[0][rateIndex]++; //total
+    priv->stats.received_rate_histogram[0][rateIndex]++;	/* total */
     priv->stats.received_rate_histogram[rcvType][rateIndex]++;
 }
 
@@ -5450,23 +5456,27 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 	rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
 	struct net_device *dev=info->dev;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-	//rx_desc_819x_usb *desc = (rx_desc_819x_usb *)skb->data;
+	/* rx_desc_819x_usb *desc = (rx_desc_819x_usb *)skb->data; */
 	rx_drvinfo_819x_usb  *driver_info = NULL;
 
-	//
-	//Get Rx Descriptor Information
-	//
+	/* Get Rx Descriptor Information */
 #ifdef USB_RX_AGGREGATION_SUPPORT
 	if (bIsRxAggrSubframe)
 	{
 		rx_desc_819x_usb_aggr_subframe *desc = (rx_desc_819x_usb_aggr_subframe *)skb->data;
 		stats->Length = desc->Length ;
 		stats->RxDrvInfoSize = desc->RxDrvInfoSize;
-		stats->RxBufShift = 0; //RxBufShift = 2 in RxDesc, but usb didn't shift bytes in fact.
+		stats->RxBufShift = 0;
+		/* RxBufShift = 2 in RxDesc,
+		 * but usb didn't shift bytes in fact.
+		 */
 		stats->bICV = desc->ICV;
 		stats->bCRC = desc->CRC32;
 		stats->bHwError = stats->bCRC|stats->bICV;
-		stats->Decrypted = !desc->SWDec;//RTL8190 set this bit to indicate that Hw does not decrypt packet
+		stats->Decrypted = !desc->SWDec;
+		/* RTL8190 set this bit to indicate
+		 * that Hw does not decrypt packet
+		 */
 	} else
 #endif
 	{
@@ -5474,11 +5484,13 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 
 		stats->Length = desc->Length;
 		stats->RxDrvInfoSize = desc->RxDrvInfoSize;
-		stats->RxBufShift = 0;//desc->Shift&0x03;
+		stats->RxBufShift = 0;		/* desc->Shift&0x03; */
 		stats->bICV = desc->ICV;
 		stats->bCRC = desc->CRC32;
 		stats->bHwError = stats->bCRC|stats->bICV;
-		//RTL8190 set this bit to indicate that Hw does not decrypt packet
+		/* RTL8190 set this bit to indicate
+		 * that Hw does not decrypt packet
+		 */
 		stats->Decrypted = !desc->SWDec;
 	}
 
@@ -5493,11 +5505,10 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 
 	if(stats->Length < 24 || stats->Length > MAX_8192U_RX_SIZE)
 		stats->bHwError |= 1;
-	//
-	//Get Driver Info
-	//
-	// TODO: Need to verify it on FGPA platform
-	//Driver info are written to the RxBuffer following rx desc
+
+	/* Get Driver Info */
+	/* TODO: Need to verify it on FGPA platform */
+	/* Driver info are written to the RxBuffer following rx desc */
 	if (stats->RxDrvInfoSize != 0) {
 		driver_info = (rx_drvinfo_819x_usb *)(skb->data + sizeof(rx_desc_819x_usb) + \
 				stats->RxBufShift);
@@ -5508,11 +5519,16 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 			ret_rate = HwRateToMRate90(driver_info->RxHT, driver_info->RxRate);
 			if(ret_rate == 0xff)
 			{
-				// Abnormal Case: Receive CRC OK packet with Rx descriptor indicating non supported rate.
-				// Special Error Handling here, 2008.05.16, by Emily
+				/* Abnormal Case: Receive CRC OK packet with Rx
+				 * descriptor indicating non supported rate.
+				 */
+				/* Special Error Handling here, 2008.05.16,
+				 * by Emily
+				 */
 
 				stats->bHwError = 1;
-				stats->rate = MGN_1M;	//Set 1M rate by default
+				stats->rate = MGN_1M;
+				/* Set 1M rate by default */
 			}else
 			{
 				stats->rate = ret_rate;
@@ -5529,15 +5545,15 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 		stats->bIsAMPDU = (driver_info->PartAggr==1);
 		stats->bFirstMPDU = (driver_info->PartAggr==1) && (driver_info->FirstAGGR==1);
 		stats->TimeStampLow = driver_info->TSFL;
-		// xiong mask it, 070514
-		//pRfd->Status.TimeStampHigh = PlatformEFIORead4Byte(Adapter, TSFR+4);
-		// stats->TimeStampHigh = read_nic_dword(dev,  TSFR+4);
+		/* xiong mask it, 070514 */
+		/* pRfd->Status.TimeStampHigh =
+		 * 			PlatformEFIORead4Byte(Adapter, TSFR+4);
+		 */
+		/* stats->TimeStampHigh = read_nic_dword(dev,  TSFR+4); */
 
 		UpdateRxPktTimeStamp8190(dev, stats);
 
-		//
-		// Rx A-MPDU
-		//
+		/* Rx A-MPDU */
 		if(driver_info->FirstAGGR==1 || driver_info->PartAggr == 1)
 			RT_TRACE(COMP_RXDESC, "driver_info->FirstAGGR = %d, driver_info->PartAggr = %d\n",
 					driver_info->FirstAGGR, driver_info->PartAggr);
@@ -5545,23 +5561,23 @@ void query_rxdesc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats,
 	}
 
 	skb_pull(skb,sizeof(rx_desc_819x_usb));
-	//
-	// Get Total offset of MPDU Frame Body
-	//
+	/* Get Total offset of MPDU Frame Body */
 	if((stats->RxBufShift + stats->RxDrvInfoSize) > 0) {
 		stats->bShift = 1;
 		skb_pull(skb,stats->RxBufShift + stats->RxDrvInfoSize);
 	}
 
 #ifdef USB_RX_AGGREGATION_SUPPORT
-	/* for the rx aggregated sub frame, the redundant space truelly contained in the packet */
+	/* for the rx aggregated sub frame, the redundant space truly
+	 * contained in the packet
+	 */
 	if(bIsRxAggrSubframe) {
 		skb_pull(skb, 8);
 	}
 #endif
 	/* for debug 2008.5.29 */
 
-	//added by vivi, for MP, 20080108
+	/* added by vivi, for MP, 20080108 */
 	stats->RxIs40MHzPacket = driver_info->BW;
 	if(stats->RxDrvInfoSize != 0)
 		TranslateRxSignalStuff819xUsb(skb, stats, driver_info);
@@ -5589,7 +5605,7 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 		.signal = 0,
 		.noise = -98,
 		.rate = 0,
-		//      .mac_time = jiffies,
+		/* .mac_time = jiffies, */
 		.freq = IEEE80211_24GHZ_BAND,
 	};
 	u32 rx_pkt_len = 0;
@@ -5605,7 +5621,7 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 	u32  PacketShiftBytes = 0;
 	rx_desc_819x_usb_aggr_subframe *RxDescr = NULL;
 	u8  PaddingBytes = 0;
-	//add just for testing
+	/* add just for testing */
 	u8   testing;
 
 #endif
@@ -5622,9 +5638,11 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 #ifdef USB_RX_AGGREGATION_SUPPORT
 		if (TempByte & BIT0) {
 			agg_skb = skb;
-			//TotalLength = agg_skb->len - 4; /*sCrcLng*/
+			/* TotalLength = agg_skb->len - 4; */ /*sCrcLng*/
 			TotalLength = stats.Length - 4; /*sCrcLng*/
-			//RT_TRACE(COMP_RECV, "%s:first aggregated packet!Length=%d\n",__func__,TotalLength);
+			/* RT_TRACE(COMP_RECV, "%s:first aggregated"
+			 *	" packet!Length=%d\n",__func__,TotalLength);
+			 */
 			/* though the head pointer has passed this position  */
 			TempDWord = *(u32 *)(agg_skb->data - 4);
 			PacketLength = (u16)(TempDWord & 0x3FFF); /*sCrcLng*/
@@ -5640,9 +5658,9 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 		ieee80211_hdr = (struct ieee80211_hdr_1addr *)skb->data;
 		unicast_packet = false;
 		if(is_broadcast_ether_addr(ieee80211_hdr->addr1)) {
-			//TODO
+			/* TODO */
 		}else if(is_multicast_ether_addr(ieee80211_hdr->addr1)){
-			//TODO
+			/* TODO */
 		}else {
 			/* unicast packet */
 			unicast_packet = true;
@@ -5658,7 +5676,7 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 		}
 #ifdef USB_RX_AGGREGATION_SUPPORT
 		testing = 1;
-		// (PipeIndex == 0) && (TempByte & BIT0) => TotalLength > 0.
+		/* (PipeIndex == 0) && (TempByte & BIT0) => TotalLength > 0. */
 		if (TotalLength > 0) {
 			PacketOccupiedLendth = PacketLength + (PacketShiftBytes + 8);
 			if ((PacketOccupiedLendth & 0xFF) != 0)
@@ -5672,7 +5690,9 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 
 			while (agg_skb->len>=GetRxPacketShiftBytes819xUsb(&stats, true)) {
 				u8 tmpCRC = 0, tmpICV = 0;
-				//RT_TRACE(COMP_RECV,"%s:aggred pkt,total_len = %d\n",__func__,agg_skb->len);
+				/* RT_TRACE(COMP_RECV,"%s:aggred pkt,total_len"
+				 *	" = %d\n",__func__,agg_skb->len);
+				 */
 				RxDescr = (rx_desc_819x_usb_aggr_subframe *)(agg_skb->data);
 				tmpCRC = RxDescr->CRC32;
 				tmpICV = RxDescr->ICV;
@@ -5700,9 +5720,9 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 				ieee80211_hdr = (struct ieee80211_hdr_1addr *)skb->data;
 				unicast_packet = false;
 				if(is_broadcast_ether_addr(ieee80211_hdr->addr1)) {
-					//TODO
+					/* TODO */
 				}else if(is_multicast_ether_addr(ieee80211_hdr->addr1)){
-					//TODO
+					/* TODO */
 				}else {
 					/* unicast packet */
 					unicast_packet = true;
@@ -5744,30 +5764,35 @@ rtl819xusb_process_received_packet(
 	struct ieee80211_rx_stats *pstats
 	)
 {
-//	bool bfreerfd=false, bqueued=false;
+	/* bool bfreerfd=false, bqueued=false; */
 	u8* 	frame;
 	u16     frame_len=0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
-//	u8			index = 0;
-//	u8			TID = 0;
-	//u16			seqnum = 0;
-	//PRX_TS_RECORD	pts = NULL;
+	/* u8			index = 0; */
+	/* u8			TID = 0; */
+	/* u16			seqnum = 0; */
+	/* PRX_TS_RECORD	pts = NULL; */
 
-	// Get shifted bytes of Starting address of 802.11 header. 2006.09.28, by Emily
-	//porting by amy 080508
+	/* Get shifted bytes of Starting address of 802.11 header.
+	 * 2006.09.28, by Emily
+	 */
+	/* porting by amy 080508 */
 	pstats->virtual_address += get_rxpacket_shiftbytes_819xusb(pstats);
 	frame = pstats->virtual_address;
 	frame_len = pstats->packetlength;
-#ifdef TODO	// by amy about HCT
+#ifdef TODO	/* by amy about HCT */
 	if(!Adapter->bInHctTest)
 		CountRxErrStatistics(Adapter, pRfd);
 #endif
 	{
-	#ifdef ENABLE_PS  //by amy for adding ps function in future
+	#ifdef ENABLE_PS	/* by amy for adding ps function in future */
 		RT_RF_POWER_STATE rtState;
-		// When RF is off, we should not count the packet for hw/sw synchronize
-		// reason, ie. there may be a duration while sw switch is changed and hw
-		// switch is being changed. 2006.12.04, by shien chang.
+		/* When RF is off, we should not count the packet for hw/sw
+		 * synchronize
+		 * reason, ie. there may be a duration while sw switch is
+		 * changed and hw switch is being changed.
+		 * 2006.12.04, by shien chang.
+		 */
 		Adapter->HalFunc.GetHwRegHandler(Adapter, HW_VAR_RF_STATE, (u8* )(&rtState));
 		if (rtState == eRfOff)
 		{
@@ -5796,15 +5821,15 @@ rtl819xusb_process_received_packet(
 
 void query_rx_cmdpkt_desc_status(struct sk_buff *skb, struct ieee80211_rx_stats *stats)
 {
-//	rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
-//	struct net_device *dev=info->dev;
-//	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
+	/* rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb; */
+	/* struct net_device *dev=info->dev; */
+	/* struct r8192_priv *priv =
+	 *			 (struct r8192_priv *)ieee80211_priv(dev);
+	 */
 	rx_desc_819x_usb *desc = (rx_desc_819x_usb *)skb->data;
-//	rx_drvinfo_819x_usb  *driver_info;
+	/* rx_drvinfo_819x_usb  *driver_info; */
 
-	//
-	//Get Rx Descriptor Information
-	//
+	/* Get Rx Descriptor Information */
 	stats->virtual_address = (u8*)skb->data;
 	stats->Length = desc->Length;
 	stats->RxDrvInfoSize = 0;
@@ -5820,14 +5845,14 @@ void rtl8192_rx_cmd(struct sk_buff *skb)
 {
 	struct rtl8192_rx_info *info = (struct rtl8192_rx_info *)skb->cb;
 	struct net_device *dev = info->dev;
-	//int ret;
-//	struct urb *rx_urb = info->urb;
+	/* int ret; */
+	/* struct urb *rx_urb = info->urb; */
 	/* TODO */
 	struct ieee80211_rx_stats stats = {
 		.signal = 0,
 		.noise = -98,
 		.rate = 0,
-		//      .mac_time = jiffies,
+		/* .mac_time = jiffies, */
 		.freq = IEEE80211_24GHZ_BAND,
 	};
 
@@ -5835,21 +5860,14 @@ void rtl8192_rx_cmd(struct sk_buff *skb)
 	{
 
 		query_rx_cmdpkt_desc_status(skb,&stats);
-		// this is to be done by amy 080508     prfd->queue_id = 1;
-
-
-		//
-		//  Process the command packet received.
-		//
+		/* this is to be done by amy 080508     prfd->queue_id = 1; */
 
+		/*  Process the command packet received. */
 		rtl819xusb_process_received_packet(dev,&stats);
-
 		dev_kfree_skb_any(skb);
 	}
 	else
 		;
-
-
 }
 
 void rtl8192_irq_rx_tasklet(struct r8192_priv *priv)
@@ -5862,7 +5880,9 @@ void rtl8192_irq_rx_tasklet(struct r8192_priv *priv)
 		switch (info->out_pipe) {
 		/* Nomal packet pipe */
 			case 3:
-				//RT_TRACE(COMP_RECV, "normal in-pipe index(%d)\n",info->out_pipe);
+				/* RT_TRACE(COMP_RECV, "normal in-pipe"
+				 *	" index(%d)\n", info->out_pipe);
+				 */
 				priv->IrpPendingCount--;
 				rtl8192_rx_nomal(skb);
 				break;
@@ -5900,13 +5920,14 @@ static const struct net_device_ops rtl8192_netdev_ops = {
 
 
 /****************************************************************************
-     ---------------------------- USB_STUFF---------------------------
-*****************************************************************************/
+ *     ---------------------------- USB_STUFF---------------------------
+ ****************************************************************************
+*/
 
 static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
-//	unsigned long ioaddr = 0;
+	/* unsigned long ioaddr = 0; */
 	struct net_device *dev = NULL;
 	struct r8192_priv *priv= NULL;
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -5923,7 +5944,7 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 
 	dev->netdev_ops = &rtl8192_netdev_ops;
 
-	 //DMESG("Oops: i'm coming\n");
+	 /* DMESG("Oops: i'm coming\n"); */
 #if WIRELESS_EXT >= 12
 #if WIRELESS_EXT < 17
 	dev->get_wireless_stats = r8192_get_wireless_stats;
@@ -5932,7 +5953,7 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 #endif
 	dev->type=ARPHRD_ETHER;
 
-	dev->watchdog_timeo = HZ*3;	//modified by john, 0805
+	dev->watchdog_timeo = HZ*3;	/* modified by john, 0805 */
 
 	if (dev_alloc_name(dev, ifname) < 0){
 		RT_TRACE(COMP_INIT, "Oops: devname already taken! Trying wlan%%d...\n");
@@ -5965,7 +5986,9 @@ fail:
 
 }
 
-//detach all the work and timer structure declared or inititialize in r8192U_init function.
+/*detach all the work and timer structure declared or
+ * inititialize in r8192U_init function.
+ */
 void rtl8192_cancel_deferred_work(struct r8192_priv* priv)
 {
 
@@ -5973,8 +5996,8 @@ void rtl8192_cancel_deferred_work(struct r8192_priv* priv)
 	cancel_delayed_work(&priv->watch_dog_wq);
 	cancel_delayed_work(&priv->update_beacon_wq);
 	cancel_work_sync(&priv->qos_activate);
-	//cancel_work_sync(&priv->SetBWModeWorkItem);
-	//cancel_work_sync(&priv->SwChnlWorkItem);
+	/* cancel_work_sync(&priv->SetBWModeWorkItem); */
+	/* cancel_work_sync(&priv->SwChnlWorkItem); */
 
 }
 
@@ -5997,12 +6020,12 @@ static void __devexit rtl8192_usb_disconnect(struct usb_interface *intf)
 			kfree(priv->pFirmware);
 			priv->pFirmware = NULL;
 		}
-	//	priv->rf_close(dev);
-//		rtl8192_SetRFPowerState(dev, eRfOff);
+		/* priv->rf_close(dev); */
+		/* rtl8192_SetRFPowerState(dev, eRfOff); */
 		rtl8192_usb_deleteendpoints(dev);
 		destroy_workqueue(priv->priv_wq);
-		//rtl8192_irq_disable(dev);
-		//rtl8192_reset(dev);
+		/* rtl8192_irq_disable(dev); */
+		/* rtl8192_reset(dev); */
 		mdelay(10);
 
 	}
@@ -6073,7 +6096,7 @@ static void __exit rtl8192_usb_module_exit(void)
 	usb_deregister(&rtl8192_usb_driver);
 
 	RT_TRACE(COMP_DOWN, "Exiting");
-//	rtl8192_proc_module_remove();
+	/* rtl8192_proc_module_remove(); */
 }
 
 
@@ -6107,12 +6130,18 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 		SECR_value |= SCR_RxUseDK;
 		SECR_value |= SCR_TxUseDK;
 	}
-	//add HWSec active enable here.
-//default using hwsec. when peer AP is in N mode only and pairwise_key_type is none_aes(which HT_IOT_ACT_PURE_N_MODE indicates it), use software security. when peer AP is in b,g,n mode mixed and pairwise_key_type is none_aes, use g mode hw security. WB on 2008.7.4
+	/* add HWSec active enable here. */
+/* default using hwsec. when peer AP is in N mode only and pairwise_key_type
+ * is none_aes(which HT_IOT_ACT_PURE_N_MODE indicates it),
+ * use software security. when peer AP is in b,g,n mode mixed and
+ * pairwise_key_type is none_aes, use g mode hw security.
+ * WB on 2008.7.4 */
 
 	ieee->hwsec_active = 1;
 
-	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep)//!ieee->hwsec_support) //add hwsec_support flag to totol control hw_sec on/off
+	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep)
+	/* !ieee->hwsec_support) */
+	/*add hwsec_support flag to totol control hw_sec on/off */
 	{
 		ieee->hwsec_active = 0;
 		SECR_value &= ~SCR_RxDecEnable;
@@ -6120,7 +6149,8 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 	RT_TRACE(COMP_SEC,"%s:, hwsec:%d, pairwise_key:%d, SECR_value:%x\n", __func__, \
 			ieee->hwsec_active, ieee->pairwise_key_type, SECR_value);
 	{
-		write_nic_byte(dev, SECR,  SECR_value);//SECR_value |  SCR_UseDK );
+		write_nic_byte(dev, SECR,  SECR_value);
+					/* SECR_value |  SCR_UseDK ); */
 	}
 }
 
@@ -6146,23 +6176,25 @@ void setKey(	struct net_device *dev,
 		usConfig |= BIT15 | (KeyType<<2);
 	else
 		usConfig |= BIT15 | (KeyType<<2) | KeyIndex;
-//	usConfig |= BIT15 | (KeyType<<2) | (DefaultKey<<5) | KeyIndex;
+	/* usConfig |= BIT15 | (KeyType<<2) | (DefaultKey<<5) | KeyIndex; */
 
 
 	for(i=0 ; i<CAM_CONTENT_COUNT; i++){
 		TargetCommand  = i+CAM_CONTENT_COUNT*EntryNo;
 		TargetCommand |= BIT31|BIT16;
 
-		if(i==0){//MAC|Config
+		if(i==0){		/* MAC|Config */
 			TargetContent = (u32)(*(MacAddr+0)) << 16|
 					(u32)(*(MacAddr+1)) << 24|
 					(u32)usConfig;
 
 			write_nic_dword(dev, WCAMI, TargetContent);
 			write_nic_dword(dev, RWCAM, TargetCommand);
-	//		printk("setkey cam =%8x\n", read_cam(dev, i+6*EntryNo));
+			/* printk("setkey cam =%8x\n",
+			 *			 read_cam(dev, i+6*EntryNo));
+			 */
 		}
-		else if(i==1){//MAC
+		else if(i==1){		/* MAC */
 			TargetContent = (u32)(*(MacAddr+2)) 	 |
 					(u32)(*(MacAddr+3)) <<  8|
 					(u32)(*(MacAddr+4)) << 16|
@@ -6171,7 +6203,7 @@ void setKey(	struct net_device *dev,
 			write_nic_dword(dev, RWCAM, TargetCommand);
 		}
 		else {
-			//Key Material
+			/* Key Material */
 			if(KeyContent !=NULL){
 			write_nic_dword(dev, WCAMI, (u32)(*(KeyContent+i-2)) );
 			write_nic_dword(dev, RWCAM, TargetCommand);
@@ -6182,7 +6214,8 @@ void setKey(	struct net_device *dev,
 }
 
 /***************************************************************************
-     ------------------- module init / exit stubs ----------------
-****************************************************************************/
+ *     ------------------- module init / exit stubs ----------------
+ ***************************************************************************
+*/
 module_init(rtl8192_usb_module_init);
 module_exit(rtl8192_usb_module_exit);
-- 
1.6.3.3

