Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2DPPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:09:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54484 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2DPPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:09:24 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lacombar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH]NEXT:drivers:staging:rtl8187se Fix typos in staging:rtl8187se
Date: Mon, 16 Apr 2012 08:09:14 -0700
Message-Id: <1334588954-14837-1-git-send-email-user@Ideapad-Z560>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <Justin P. Mattock>

The below patch fixes some typos that I found while reading. 

Signed-off-by: Justin P. Mattock <Justin P. Mattock>

---
 drivers/staging/rtl8187se/Makefile                 |    2 +-
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |   14 ++++----
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   24 ++++++++--------
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    2 +-
 drivers/staging/rtl8187se/r8180.h                  |   10 +++---
 drivers/staging/rtl8187se/r8180_core.c             |   30 ++++++++++----------
 drivers/staging/rtl8187se/r8180_dm.c               |   16 +++++-----
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    4 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    6 ++--
 drivers/staging/rtl8187se/r8180_wx.h               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |   10 +++---
 14 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
index 72db504..91d1aa2 100644
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -10,7 +10,7 @@ ccflags-y += -DHIGH_POWER
 ccflags-y += -DSW_DIG
 ccflags-y += -DRATE_ADAPT
 
-#enable it for legacy power save, disable it for leisure  power save
+#enable it for legacy power save, disable it for leisure power save
 ccflags-y += -DENABLE_LPS
 
 
diff --git a/drivers/staging/rtl8187se/ieee80211/dot11d.c b/drivers/staging/rtl8187se/ieee80211/dot11d.c
index 309bb8b..0e93eb0 100644
--- a/drivers/staging/rtl8187se/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8187se/ieee80211/dot11d.c
@@ -55,7 +55,7 @@ Dot11d_Reset(struct ieee80211_device *ieee)
 
 //
 //	Description:
-//		Update country IE from Beacon or Probe Resopnse
+//		Update country IE from Beacon or Probe Response
 //		and configure PHY for operation in the regulatory domain.
 //
 //	TODO:
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index 40dd715..b94c48b 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -834,7 +834,7 @@ enum ieee80211_state {
 	/* the association procedure is sending AUTH request*/
 	IEEE80211_ASSOCIATING_AUTHENTICATING,
 
-	/* the association procedure has successfully authentcated
+	/* the association procedure has successfully authenticated
 	 * and is sending association request
 	 */
 	IEEE80211_ASSOCIATING_AUTHENTICATED,
@@ -934,7 +934,7 @@ struct ieee80211_device {
 			   * with RX of broad/multicast frames */
 
 	/* Fragmentation structures */
-	// each streaming contain a entry
+	/* each stream contains an entry */
 	struct ieee80211_frag_entry frag_cache[17][IEEE80211_FRAG_CACHE_LEN];
 	unsigned int frag_next_idx[17];
 	u16 fts; /* Fragmentation Threshold */
@@ -972,7 +972,7 @@ struct ieee80211_device {
 
 	int rate;       /* current rate */
 	int basic_rate;
-	//FIXME: pleace callback, see if redundant with softmac_features
+	//FIXME: please callback, see if redundant with softmac_features
 	short active_scan;
 
 	/* this contains flags for selectively enable softmac support */
@@ -1106,7 +1106,7 @@ struct ieee80211_device {
 
 	/* used instead of hard_start_xmit (not softmac_hard_start_xmit)
 	 * if the IEEE_SOFTMAC_TX_QUEUE feature is used to TX data
-	 * frames. I the option IEEE_SOFTMAC_SINGLE_QUEUE is also set
+	 * frames. If the option IEEE_SOFTMAC_SINGLE_QUEUE is also set
 	 * then also management frames are sent via this callback.
 	 * This function can't sleep.
 	 */
@@ -1124,7 +1124,7 @@ struct ieee80211_device {
 
 	/* ask to the driver to retune the radio .
 	 * This function can sleep. the driver should ensure
-	 * the radio has been swithced before return.
+	 * the radio has been switched before return.
 	 */
 	void (*set_chan)(struct net_device *dev,short ch);
 
@@ -1135,7 +1135,7 @@ struct ieee80211_device {
 	 * The syncro version is similar to the start_scan but
 	 * does not return until all channels has been scanned.
 	 * this is called in user context and should sleep,
-	 * it is called in a work_queue when swithcing to ad-hoc mode
+	 * it is called in a work_queue when switching to ad-hoc mode
 	 * or in behalf of iwlist scan when the card is associated
 	 * and root user ask for a scan.
 	 * the function stop_scan should stop both the syncro and
@@ -1196,7 +1196,7 @@ struct ieee80211_device {
 /* Generate probe requests */
 #define IEEE_SOFTMAC_PROBERQ (1<<4)
 
-/* Generate respones to probe requests */
+/* Generate response to probe requests */
 #define IEEE_SOFTMAC_PROBERS (1<<5)
 
 /* The ieee802.11 stack will manages the netif queue
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 0f909b7..8173240 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -42,7 +42,7 @@ short ieee80211_is_shortslot(const struct ieee80211_network *net)
 	return net->capability & WLAN_CAPABILITY_SHORT_SLOT;
 }
 
-/* returns the total length needed for pleacing the RATE MFIE
+/* returns the total length needed for placing the RATE MFIE
  * tag and the EXTENDED RATE MFIE tag if needed.
  * It encludes two bytes per tag for the tag itself and its len
  */
@@ -60,7 +60,7 @@ unsigned int ieee80211_MFIE_rate_len(struct ieee80211_device *ieee)
 	return rate_len;
 }
 
-/* pleace the MFIE rate, tag to the memory (double) poined.
+/* place the MFIE rate, tag to the memory (double) poised.
  * Then it updates the pointer so that
  * it points after the new MFIE tag added.
  */
@@ -467,7 +467,7 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 		 *    So we switch to IEEE80211_LINKED_SCANNING to remember
 		 *    that we are still logically linked (not interested in
 		 *    new network events, despite for updating the net list,
-		 *    but we are temporarly 'unlinked' as the driver shall
+		 *    but we are temporarily 'unlinked' as the driver shall
 		 *    not filter RX frames and the channel is changing.
 		 * So the only situation in witch are interested is to check
 		 * if the state become LINKED because of the #1 situation
@@ -530,7 +530,7 @@ void ieee80211_softmac_ips_scan_syncro(struct ieee80211_device *ieee)
                  *    So we switch to IEEE80211_LINKED_SCANNING to remember
                  *    that we are still logically linked (not interested in
                  *    new network events, despite for updating the net list,
-                 *    but we are temporarly 'unlinked' as the driver shall
+                 *    but we are temporarily 'unlinked' as the driver shall
                  *    not filter RX frames and the channel is changing.
                  * So the only situation in witch are interested is to check
                  * if the state become LINKED because of the #1 situation
@@ -1140,7 +1140,7 @@ void ieee80211_associate_abort(struct ieee80211_device *ieee)
 
 	ieee->associate_seq++;
 
-	/* don't scan, and avoid to have the RX path possibily
+	/* don't scan, and avoid to have the RX path possibly
 	 * try again to associate. Even do not react to AUTH or
 	 * ASSOC response. Just wait for the retry wq to be scheduled.
 	 * Here we will check if there are good nets to associate
@@ -1346,14 +1346,14 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
 		//printk("apset=%d apmatch=%d ssidset=%d ssidbroad=%d ssidmatch=%d\n",apset,apmatch,ssidset,ssidbroad,ssidmatch);
 
 		if (	/* if the user set the AP check if match.
-			 * if the network does not broadcast essid we check the user supplyed ANY essid
+			 * if the network does not broadcast essid we check the user supplied ANY essid
 			 * if the network does broadcast and the user does not set essid it is OK
 			 * if the network does broadcast and the user did set essid chech if essid match
 			 */
 				( apset && apmatch &&
 				  ((ssidset && ssidbroad && ssidmatch) || (ssidbroad && !ssidset) || (!ssidbroad && ssidset)) ) ||
 				/* if the ap is not set, check that the user set the bssid
-				 * and the network does bradcast and that those two bssid matches
+				 * and the network does broadcast and that those two bssid matches
 				 */
 				(!apset && ssidset && ssidbroad && ssidmatch)
 		   ){
@@ -1821,7 +1821,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 					while (left >= sizeof(struct ieee80211_info_element_hdr)) {
 						if (sizeof(struct ieee80211_info_element_hdr) + info_element->len > left) {
-							printk(KERN_WARNING "[re]associate reeponse error!");
+							printk(KERN_WARNING "[re]associate response error!");
 							return 1;
 						}
 						switch (info_element->id) {
@@ -2184,15 +2184,15 @@ void ieee80211_start_ibss_wq(struct work_struct *work)
 
 	if(ieee->state == IEEE80211_NOLINK)
 		ieee->current_network.channel = 10;
-	/* if not then the state is not linked. Maybe the user swithced to
+	/* if not then the state is not linked. Maybe the user switched to
 	 * ad-hoc mode just after being in monitor mode, or just after
 	 * being very few time in managed mode (so the card have had no
 	 * time to scan all the chans..) or we have just run up the iface
 	 * after setting ad-hoc mode. So we have to give another try..
 	 * Here, in ibss mode, should be safe to do this without extra care
-	 * (in bss mode we had to make sure no-one tryed to associate when
+	 * (in bss mode we had to make sure no-one tried to associate when
 	 * we had just checked the ieee->state and we was going to start the
-	 * scan) beacause in ibss mode the ieee80211_new_net function, when
+	 * scan) because in ibss mode the ieee80211_new_net function, when
 	 * finds a good net, just set the ieee->state to IEEE80211_LINKED,
 	 * so, at worst, we waste a bit of time to initiate an unneeded syncro
 	 * scan, that will stop at the first round because it sees the state
@@ -2342,7 +2342,7 @@ void ieee80211_associate_retry_wq(struct work_struct *work)
 		goto exit;
 	/* until we do not set the state to IEEE80211_NOLINK
 	* there are no possibility to have someone else trying
-	* to start an association procdure (we get here with
+	* to start an association procedure (we get here with
 	* ieee->state = IEEE80211_ASSOCIATING).
 	* When we set the state to IEEE80211_NOLINK it is possible
 	* that the RX path run an attempt to associate, but
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index e46ff2f..5d20490 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -362,7 +362,7 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
 		ieee80211_stop_protocol(ieee);
 
 	/* this is just to be sure that the GET wx callback
-	 * has consisten infos. not needed otherwise
+	 * has consistent infos. not needed otherwise
 	 */
 	spin_lock_irqsave(&ieee->lock, flags);
 
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
index 552115c..77bb068 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
@@ -328,7 +328,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb,
 	//printk(KERN_WARNING "upper layer packet!\n");
 	spin_lock_irqsave(&ieee->lock, flags);
 
-	/* If there is no driver handler to take the TXB, dont' bother
+	/* If there is no driver handler to take the TXB, don't bother
 	 * creating it... */
 	if ((!ieee->hard_start_xmit && !(ieee->softmac_features & IEEE_SOFTMAC_TX_QUEUE))||
 	   ((!ieee->softmac_data_hard_start_xmit && (ieee->softmac_features & IEEE_SOFTMAC_TX_QUEUE)))) {
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index ca414a9..c7917b2 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -363,7 +363,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 				       (*crypt)->priv);
 		sec.flags |= (1 << key);
 		/* This ensures a key will be activated if no key is
-		 * explicitely set */
+		 * explicitly set */
 		if (key == sec.active_key)
 			sec.flags |= SEC_ACTIVE_KEY;
 		ieee->tx_keyidx = key;//by wb 080312
diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index a2c46ae..2682afb 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -11,7 +11,7 @@
 
    Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
 
-   We want to tanks the Authors of those projects and the Ndiswrapper
+   We want to thanks the Authors of those projects and the Ndiswrapper
    project Authors.
 */
 
@@ -514,12 +514,12 @@ typedef struct r8180_priv
 	bool bDefaultAntenna1;
 	u8 SignalStrength;
 	long Stats_SignalStrength;
-	long LastSignalStrengthInPercent; // In percentange, used for smoothing, e.g. Moving Average.
+	long LastSignalStrengthInPercent; // In percentage, used for smoothing, e.g. Moving Average.
 	u8	 SignalQuality; // in 0-100 index.
 	long Stats_SignalQuality;
 	long RecvSignalPower; // in dBm.
 	long Stats_RecvSignalPower;
-	u8	 LastRxPktAntenna;	// +by amy 080312 Antenn which received the lasted packet. 0: Aux, 1:Main. Added by Roger, 2008.01.25.
+	u8	 LastRxPktAntenna;	// +by amy 080312 Antenna which received the lasted packet. 0: Aux, 1:Main. Added by Roger, 2008.01.25.
 	u32 AdRxOkCnt;
 	long AdRxSignalStrength;
 	u8 CurrAntennaIndex;			// Index to current Antenna (both Tx and Rx).
@@ -530,7 +530,7 @@ typedef struct r8180_priv
 	long AdRxSsThreshold;			// Signal strength threshold to switch antenna.
 	long AdMaxRxSsThreshold;			// Max value of AdRxSsThreshold.
 	bool bAdSwitchedChecking;		// TRUE if we shall shall check Rx signal strength for last time switching antenna.
-	long AdRxSsBeforeSwitched;		// Rx signal strength before we swithed antenna.
+	long AdRxSsBeforeSwitched;		// Rx signal strength before we switched antenna.
 	struct timer_list SwAntennaDiversityTimer;
 //by amy for antenna
 //{by amy 080312
@@ -553,7 +553,7 @@ typedef struct r8180_priv
 	bool				bDigMechanism; // TRUE if DIG is enabled, FALSE ow.
 	bool				bRegHighPowerMechanism; // For High Power Mechanism. 061010, by rcnjko.
 	u32					FalseAlarmRegValue;
-	u8					RegDigOfdmFaUpTh; // Upper threhold of OFDM false alarm, which is used in DIG.
+	u8					RegDigOfdmFaUpTh; // Upper threshold of OFDM false alarm, which is used in DIG.
 	u8					DIG_NumberFallbackVote;
 	u8					DIG_NumberUpgradeVote;
 	// For HW antenna diversity, added by Roger, 2008.01.30.
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 4fe52f6..a513ec7 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1329,7 +1329,7 @@ u16 N_DBPSOfRate(u16 DataRate)
 }
 
 /*
- * For Netgear case, they want good-looking singal strength.
+ * For Netgear case, they want good-looking signal strength.
  */
 long NetgearSignalStrengthTranslate(long LastSS, long CurrSS)
 {
@@ -1380,7 +1380,7 @@ long TranslateToDbm8185(u8 SignalStrengthIndex)
 
 /*
  * Perform signal smoothing for dynamic mechanism.
- * This is different with PerformSignalSmoothing8185 in smoothing fomula.
+ * This is different with PerformSignalSmoothing8185 in smoothing formula.
  * No dramatic adjustion is apply because dynamic mechanism need some degree
  * of correctness. Ported from 8187B.
  */
@@ -1535,7 +1535,7 @@ void rtl8180_rx(struct net_device *dev)
 			/* HW is probably passing several buggy frames
 			* without FD or LD flag set.
 			* Throw this garbage away to prevent skb
-			* memory exausting
+			* memory exhausting
 			*/
 			if (!priv->rx_skb_complete)
 				dev_kfree_skb_any(priv->rx_skb);
@@ -1648,14 +1648,14 @@ void rtl8180_rx(struct net_device *dev)
 			priv->Stats_SignalQuality = (long)(priv->Stats_SignalQuality * 5 + (long)priv->SignalQuality + 5) / 6;
 			priv->Stats_RecvSignalPower = (long)(priv->Stats_RecvSignalPower * 5 + priv->RecvSignalPower - 1) / 6;
 
-		/* Figure out which antenna that received the lasted packet. */
+		/* Figure out which antenna that received the last packet. */
 			priv->LastRxPktAntenna = Antenna ? 1 : 0; /* 0: aux, 1: main. */
 			SwAntennaDiversityRxOk8185(dev, priv->SignalStrength);
 		}
 
 		if (first) {
 			if (!priv->rx_skb_complete) {
-				/* seems that HW sometimes fails to reiceve and
+				/* seems that HW sometimes fails to receive and
 				   doesn't provide the last descriptor */
 				dev_kfree_skb_any(priv->rx_skb);
 				priv->stats.rxnolast++;
@@ -1672,7 +1672,7 @@ void rtl8180_rx(struct net_device *dev)
 			priv->rx_skb_complete = 0;
 			priv->rx_skb->dev = dev;
 		} else {
-			/* if we are here we should  have already RXed
+			/* if we are here we should have already RXed
 			* the first frame.
 			* If we get here and the skb is not allocated then
 			* we have just throw out garbage (skb not allocated)
@@ -1821,15 +1821,15 @@ rate) {
 /*
  * This is a rough attempt to TX a frame
  * This is called by the ieee 80211 stack to TX management frames.
- * If the ring is full packet are dropped (for data frame the queue
+ * If the ring is full packets are dropped (for data frame the queue
  * is stopped before this can happen). For this reason it is better
  * if the descriptors are larger than the largest management frame
- * we intend to TX: i'm unsure what the HW does if it will not found
+ * we intend to TX: i'm unsure what the HW does if it will not find
  * the last fragment of a frame because it has been dropped...
  * Since queues for Management and Data frames are different we
  * might use a different lock than tx_lock (for example mgmt_tx_lock)
  */
-/* these function may loops if invoked with 0 descriptors or 0 len buffer */
+/* these function may loop if invoked with 0 descriptors or 0 len buffer */
 int rtl8180_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -2378,7 +2378,7 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 				u8		u1bAIFS;
 				u32		u4bAcParam;
 				pAcParam = (PAC_PARAM)(&AcParam);
-				/* Retrive paramters to udpate. */
+				/* Retrieve paramters to update. */
 				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
 				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
 					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|
@@ -2414,7 +2414,7 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 			u8		u1bAIFS;
 			u32		u4bAcParam;
 
-			/* Retrive paramters to udpate. */
+			/* Retrieve paramters to update. */
 			eACI = pAcParam->f.AciAifsn.f.ACI;
 			/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
 			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
@@ -2700,7 +2700,7 @@ short rtl8180_init(struct net_device *dev)
 	priv->bTxPowerTrack = false;
 	priv->ThermalMeter = 0;
 	priv->FalseAlarmRegValue = 0;
-	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threhold of OFDM false alarm, which is used in DIG. */
+	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threshold of OFDM false alarm, which is used in DIG. */
 	priv->DIG_NumberFallbackVote = 0;
 	priv->DIG_NumberUpgradeVote = 0;
 	priv->LastSignalStrengthInPercent = 0;
@@ -2896,7 +2896,7 @@ short rtl8180_init(struct net_device *dev)
 		priv->chtxpwr_ofdm[i+1] = (word & 0xff00) >> 8;
 	}
 
-	/* 3Read crystal calibtration and thermal meter indication on 87SE. */
+	/* 3Read crystal calibration and thermal meter indication on 87SE. */
 	eeprom_93cx6_read(&eeprom, EEPROM_RSV>>1, &tmpu16);
 
 	/* Crystal calibration for Xin and Xout resp. */
@@ -3140,7 +3140,7 @@ void rtl8180_adapter_start(struct net_device *dev)
 
 	/*
 	 * The following is very strange. seems to be that 1 means test mode,
-	 * but we need to acknolwledges the nic when a packet is ready
+	 * but we need to acknowledges the nic when a packet is ready
 	 * although we set it to 0
 	 */
 
@@ -3971,7 +3971,7 @@ irqreturn_t rtl8180_interrupt(int irq, void *netdev, struct pt_regs *regs)
 	}
 
 	if (inta == 0xffff) {
-		/* HW disappared */
+		/* HW disappeared */
 		spin_unlock_irqrestore(&priv->irq_th_lock, flags);
 		return IRQ_HANDLED;
 	}
diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index 4d7a595..b8f2ba0 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -2,7 +2,7 @@
 #include "r8180_hw.h"
 #include "r8180_93cx6.h"
 
- /*	Return TRUE if we shall perform High Power Mecahnism, FALSE otherwise. */
+ /*	Return TRUE if we shall perform High Power Mechanism, FALSE otherwise. */
 #define RATE_ADAPTIVE_TIMER_PERIOD      300
 
 bool CheckHighPower(struct net_device *dev)
@@ -105,7 +105,7 @@ void rtl8180_tx_pw_wq(struct work_struct *work)
 
 
 /*
- *	Return TRUE if we shall perform DIG Mecahnism, FALSE otherwise.
+ *	Return TRUE if we shall perform DIG Mechanism, FALSE otherwise.
  */
 bool CheckDig(struct net_device *dev)
 {
@@ -507,7 +507,7 @@ void StaRateAdaptive87SE(struct net_device *dev)
 	 *		and retry rate.
 	 * (3) Remove all Initial Gain Updates over OFDM rate. To avoid the complicated
 	 *		situation, Initial Gain Update is upon on DIG mechanism except CCK rate.
-	 * (4) Add the mehanism of trying to upgrade tx rate.
+	 * (4) Add the mechanism of trying to upgrade tx rate.
 	 * (5) Record the information of upping tx rate to avoid trying upping tx rate constantly.
 	 *
 	 */
@@ -528,7 +528,7 @@ void StaRateAdaptive87SE(struct net_device *dev)
 	if (priv->bTryuping == true) {
 		/* 2 For Test Upgrading mechanism
 		 * Note:
-		 *	Sometimes the throughput is upon on the capability bwtween the AP and NIC,
+		 *	Sometimes the throughput is upon on the capability between the AP and NIC,
 		 *	thus the low data rate does not improve the performance.
 		 *	We randomly upgrade the data rate and check if the retry rate is improved.
 		 */
@@ -704,7 +704,7 @@ void StaRateAdaptive87SE(struct net_device *dev)
 
 			/* 
 			 * The difference in throughput between 48Mbps and 36Mbps is 8M.
-			 * So, we must be carefully in this rate scale. Isaiah 2008-02-15.
+			 * So, we must be careful in this rate scale. Isaiah 2008-02-15.
 			 */
 			if (((priv->CurrentOperaRate == 72) || (priv->CurrentOperaRate == 48) || (priv->CurrentOperaRate == 36)) &&
 				(priv->FailTxRateCount > 2))
@@ -1009,7 +1009,7 @@ void SwAntennaDiversity(struct net_device *dev)
 			if (priv->AdCheckPeriod > priv->AdMaxCheckPeriod)
 				priv->AdCheckPeriod = priv->AdMaxCheckPeriod;
 
-			/* Wrong deceision => switch back. */
+			/* Wrong decision => switch back. */
 			SwitchAntenna(dev);
 		} else {
 		/* Rx Signal Strength is improved. */
@@ -1057,7 +1057,7 @@ void SwAntennaDiversity(struct net_device *dev)
 		}
 		/*
 		 * <Roger_Notes> We evaluate Rx signal strength ONLY when default antenna
-		 * didn't changed by HW evaluation.
+		 * didn't change by HW evaluation.
 		 * 2008.02.27.
 		 *
 		 * [TRC Dell Lab] SignalStrength is inaccuracy. Isaiah 2008-03-05
@@ -1098,7 +1098,7 @@ void SwAntennaDiversity(struct net_device *dev)
 	priv->AdAuxAntennaRxOkCnt = 0;
 }
 
- /*	Return TRUE if we shall perform Tx Power Tracking Mecahnism, FALSE otherwise. */
+ /*	Return TRUE if we shall perform Tx Power Tracking Mechanism, FALSE otherwise. */
 bool CheckTxPwrTracking(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index ee5b867..d28c1d9 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -190,7 +190,7 @@ static void rtl8225_SetTXPowerLevel(struct net_device *dev, short ch)
 		write_phy_cck(dev, 0x44 + i, power);
 	}
 
-	/* FIXME Is this delay really needeed ? */
+	/* FIXME Is this delay really needed ? */
 	force_pci_posting(dev);
 	mdelay(1);
 
@@ -479,7 +479,7 @@ s8 DbmToTxPwrIdx(struct r8180_priv *priv, WIRELESS_MODE WirelessMode,
 
 	/*
 	 * TRUE if we want to use a default implementation.
-	 * We shall set it to FALSE when we have exact translation formular
+	 * We shall set it to FALSE when we have exact translation formula
 	 * for target IC. 070622, by rcnjko.
 	 */
 	if (bUseDefault) {
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 303ec69..46ee6f4 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -13,7 +13,7 @@
 
 	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
 
-	We want to tanks the Authors of those projects and the Ndiswrapper
+	We want to thanks the Authors of those projects and the Ndiswrapper
 	project Authors.
 */
 
@@ -1181,7 +1181,7 @@ static iw_handler r8180_wx_handlers[] =	{
 		r8180_wx_set_wap,			/* SIOCSIWAP */
 		r8180_wx_get_wap,			/* SIOCGIWAP */
 		r8180_wx_set_mlme,			/* SIOCSIWMLME*/
-		dummy,					/* SIOCGIWAPLIST -- depricated */
+		dummy,					/* SIOCGIWAPLIST -- deprecated */
 		r8180_wx_set_scan,			/* SIOCSIWSCAN */
 		r8180_wx_get_scan,			/* SIOCGIWSCAN */
 		r8180_wx_set_essid,			/* SIOCSIWESSID */
@@ -1369,7 +1369,7 @@ static inline int is_same_network(struct ieee80211_network *src,
 			(dst->capability & WLAN_CAPABILITY_BSS)));
 }
 
-/* WB modefied to show signal to GUI on 18-01-2008 */
+/* WB modified to show signal to GUI on 18-01-2008 */
 static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
diff --git a/drivers/staging/rtl8187se/r8180_wx.h b/drivers/staging/rtl8187se/r8180_wx.h
index 735d03d..4081914 100644
--- a/drivers/staging/rtl8187se/r8180_wx.h
+++ b/drivers/staging/rtl8187se/r8180_wx.h
@@ -7,7 +7,7 @@
 	Parts of this driver are based on the rtl8180 driver skeleton from Patric Schenke & Andres Salomon
 	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
 
-	We want to tanks the Authors of such projects and the Ndiswrapper project Authors.
+	We want to thanks the Authors of such projects and the Ndiswrapper project Authors.
 */
 
 /* this file (will) contains wireless extension handlers*/
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index af9be96..9144957 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -1008,7 +1008,7 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 				u8		u1bAIFS;
 				u32		u4bAcParam;
 
-				/*  Retrive paramters to udpate. */
+				/*  Retrieve paramters to update. */
 				eACI = pAcParam->f.AciAifsn.f.ACI;
 				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * ChnlAccessSetting->SlotTimeTimer + aSifsTime;
 				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|
@@ -1104,7 +1104,7 @@ void ActSetWirelessMode8185(struct net_device *dev, u8 btWirelessMode)
 		return;
 	}
 
-	/* 1. Assign wireless mode to swtich if necessary. */
+	/* 1. Assign wireless mode to switch if necessary. */
 	if (btWirelessMode == WIRELESS_MODE_AUTO) {
 		if ((btSupportedWirelessMode & WIRELESS_MODE_A)) {
 			btWirelessMode = WIRELESS_MODE_A;
@@ -1124,7 +1124,7 @@ void ActSetWirelessMode8185(struct net_device *dev, u8 btWirelessMode)
  	 * 2. Swtich band: RF or BB specific actions,
 	 * for example, refresh tables in omc8255, or change initial gain if necessary.
 	 * Nothing to do for Zebra to switch band.
-	 * Update current wireless mode if we swtich to specified band successfully. 
+	 * Update current wireless mode if we switch to specified band successfully. 
 	 */
 
 	ieee->mode = (WIRELESS_MODE)btWirelessMode;
@@ -1242,7 +1242,7 @@ bool MgntDisconnect(struct net_device *dev, u8 asRsn)
 			 */
 			MgntDisconnectAP(dev, asRsn);
 		}
-		/* Inidicate Disconnect, 2005.02.23, by rcnjko.	*/
+		/* Indicate Disconnect, 2005.02.23, by rcnjko.	*/
 	}
 	return true;
 }
@@ -1416,7 +1416,7 @@ void IPSEnter(struct net_device *dev)
 		 *	Do not enter IPS in the following conditions:
 		 *	(1) RF is already OFF or Sleep
 		 *	(2) bSwRfProcessing (indicates the IPS is still under going)
-		 *	(3) Connectted (only disconnected can trigger IPS)
+		 *	(3) Connected (only disconnected can trigger IPS)
 		 *	(4) IBSS (send Beacon)
 		 *	(5) AP mode (send Beacon)
 		 */
-- 
1.7.5.4

