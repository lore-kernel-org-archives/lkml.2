Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2DWOhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:37:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38565 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab2DWOhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:37:00 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: seanm@seanm.ca, Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging: rtl8192e: Fix typos. 
Date: Mon, 23 Apr 2012 07:36:52 -0700
Message-Id: <1335191812-17071-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes some typos that I found while doing a little bit of reading in the
staging directory.

 drivers/staging/rtl8192e/rtl8192e/r819xE_phyreg.h |    4 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c      |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c        |    2 +-
 drivers/staging/rtl8192e/rtllib.h                 |   18 ++++++------
 drivers/staging/rtl8192e/rtllib_rx.c              |    4 +-
 drivers/staging/rtl8192e/rtllib_softmac.c         |   32 ++++++++++----------
 drivers/staging/rtl8192e/rtllib_softmac_wx.c      |    4 +-
 drivers/staging/rtl8192e/rtllib_tx.c              |    6 ++--
 drivers/staging/rtl8192e/rtllib_wx.c              |    2 +-
 9 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r819xE_phyreg.h b/drivers/staging/rtl8192e/rtl8192e/r819xE_phyreg.h
index d5de279..970298b 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r819xE_phyreg.h
+++ b/drivers/staging/rtl8192e/rtl8192e/r819xE_phyreg.h
@@ -306,7 +306,7 @@
 #define bRFStart                  	0x0000f000
 #define bBBStart                  	0x000000f0
 #define bBBCCKStart               	0x0000000f
-/* Reg)x814 */
+/* Reg x814 */
 #define bPAEnd                    	0xf
 #define bTREnd                    	0x0f000000
 #define bRFEnd                    	0x000f0000
@@ -844,7 +844,7 @@
 #define bRTL8258_RxLPFBW          0xc00
 #define bRTL8258_RSSILPFBW        0xc0
 
-/* byte endable for sb_write */
+/* byte enable for sb_write */
 #define bByte0                    0x1
 #define bByte1                    0x2
 #define bByte2                    0x4
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 7c676c2..97a5f49 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -1025,7 +1025,7 @@ static int rtl8192_sta_down(struct net_device *dev, bool shutdownrf)
 			break;
 		}
 		RT_TRACE(COMP_DBG, "===>%s():RF is in progress, need to wait "
-			 "until rf chang is done.\n", __func__);
+			 "until rf change is done.\n", __func__);
 		mdelay(1);
 		RFInProgressTimeOut++;
 		spin_lock_irqsave(&priv->rf_ps_lock, flags);
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index f026b71..2dfb0f0 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -493,7 +493,7 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_device *dev)
 
 				if (priv->bResetInProgress) {
 					RT_TRACE(COMP_POWER_TRACKING,
-						 "we are in slient reset progress, so return\n");
+						 "we are in silent reset progress, so return\n");
 					write_nic_byte(dev, Pw_Track_Flag, 0);
 					write_nic_byte(dev, FW_Busy_Flag, 0);
 					return;
diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index e26aec8..d7460ae 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -169,7 +169,7 @@ struct cb_desc {
 
 	u8 nStuckCount;
 
-	/* Tx Firmware Relaged flags (10-11)*/
+	/* Tx Firmware Related flags (10-11)*/
 	u8 bCTSEnable:1;
 	u8 bRTSEnable:1;
 	u8 bUseShortGI:1;
@@ -1690,7 +1690,7 @@ enum rtllib_state {
 	/* the association procedure is sending AUTH request*/
 	RTLLIB_ASSOCIATING_AUTHENTICATING,
 
-	/* the association procedure has successfully authentcated
+	/* the association procedure has successfully authenticated
 	 * and is sending association request
 	 */
 	RTLLIB_ASSOCIATING_AUTHENTICATED,
@@ -2409,7 +2409,7 @@ struct rtllib_device {
 
 	/* used instead of hard_start_xmit (not softmac_hard_start_xmit)
 	 * if the IEEE_SOFTMAC_TX_QUEUE feature is used to TX data
-	 * frames. I the option IEEE_SOFTMAC_SINGLE_QUEUE is also set
+	 * frames. If the option IEEE_SOFTMAC_SINGLE_QUEUE is also set
 	 * then also management frames are sent via this callback.
 	 * This function can't sleep.
 	 */
@@ -2422,12 +2422,12 @@ struct rtllib_device {
 	 */
 	void (*data_hard_stop)(struct net_device *dev);
 
-	/* OK this is complementar to data_poll_hard_stop */
+	/* OK this is complementing to data_poll_hard_stop */
 	void (*data_hard_resume)(struct net_device *dev);
 
 	/* ask to the driver to retune the radio .
 	 * This function can sleep. the driver should ensure
-	 * the radio has been swithced before return.
+	 * the radio has been switched before return.
 	 */
 	void (*set_chan)(struct net_device *dev, short ch);
 
@@ -2438,7 +2438,7 @@ struct rtllib_device {
 	 * The syncro version is similar to the start_scan but
 	 * does not return until all channels has been scanned.
 	 * this is called in user context and should sleep,
-	 * it is called in a work_queue when swithcing to ad-hoc mode
+	 * it is called in a work_queue when switching to ad-hoc mode
 	 * or in behalf of iwlist scan when the card is associated
 	 * and root user ask for a scan.
 	 * the fucntion stop_scan should stop both the syncro and
@@ -2481,7 +2481,7 @@ struct rtllib_device {
 				     struct rtllib_network *network);
 
 
-	/* check whether Tx hw resouce available */
+	/* check whether Tx hw resource available */
 	short (*check_nic_enough_desc)(struct net_device *dev, int queue_index);
 	short (*get_nic_desc_num)(struct net_device *dev, int queue_index);
 	void (*SetBWModeHandler)(struct net_device *dev,
@@ -2543,10 +2543,10 @@ struct rtllib_device {
 /* Generate probe requests */
 #define IEEE_SOFTMAC_PROBERQ (1<<4)
 
-/* Generate respones to probe requests */
+/* Generate response to probe requests */
 #define IEEE_SOFTMAC_PROBERS (1<<5)
 
-/* The ieee802.11 stack will manages the netif queue
+/* The ieee802.11 stack will manage the netif queue
  * wake/stop for the driver, taking care of 802.11
  * fragmentation. See softmac.c for details. */
 #define IEEE_SOFTMAC_TX_QUEUE (1<<7)
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 13979b5..40a59c9 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -496,7 +496,7 @@ void rtllib_indicate_packets(struct rtllib_device *ieee, struct rtllib_rxb **prx
 				memcpy(skb_push(sub_skb, ETH_ALEN), prxb->dst, ETH_ALEN);
 			}
 
-			/* Indicat the packets to upper layer */
+			/* Indicate the packets to upper layer */
 			if (sub_skb) {
 				stats->rx_packets++;
 				stats->rx_bytes += sub_skb->len;
@@ -1233,7 +1233,7 @@ static void rtllib_rx_indicate_pkt_legacy(struct rtllib_device *ieee,
 			if (is_multicast_ether_addr(dst))
 				ieee->stats.multicast++;
 
-			/* Indicat the packets to upper layer */
+			/* Indicate the packets to upper layer */
 			memset(sub_skb->cb, 0, sizeof(sub_skb->cb));
 			sub_skb->protocol = eth_type_trans(sub_skb, dev);
 			sub_skb->dev = dev;
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index c5a15db..236477d 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -31,7 +31,7 @@ short rtllib_is_shortslot(const struct rtllib_network *net)
 	return net->capability & WLAN_CAPABILITY_SHORT_SLOT_TIME;
 }
 
-/* returns the total length needed for pleacing the RATE MFIE
+/* returns the total length needed for placing the RATE MFIE
  * tag and the EXTENDED RATE MFIE tag if needed.
  * It encludes two bytes per tag for the tag itself and its len
  */
@@ -49,7 +49,7 @@ static unsigned int rtllib_MFIE_rate_len(struct rtllib_device *ieee)
 	return rate_len;
 }
 
-/* pleace the MFIE rate, tag to the memory (double) poined.
+/* place the MFIE rate, tag to the memory (double) pointed.
  * Then it updates the pointer so that
  * it points after the new MFIE tag added.
  */
@@ -557,7 +557,7 @@ void rtllib_softmac_scan_syncro(struct rtllib_device *ieee, u8 is_mesh)
 		 *    new network events, despite for updating the net list,
 		 *    but we are temporarly 'unlinked' as the driver shall
 		 *    not filter RX frames and the channel is changing.
-		 * So the only situation in witch are interested is to check
+		 * So the only situation in which are interested is to check
 		 * if the state become LINKED because of the #1 situation
 		 */
 
@@ -1681,7 +1681,7 @@ inline void rtllib_softmac_new_net(struct rtllib_device *ieee,
 
 		/* if the user set the AP check if match.
 		 * if the network does not broadcast essid we check the
-		 *	 user supplyed ANY essid
+		 *	 user supplied ANY essid
 		 * if the network does broadcast and the user does not set
 		 *	 essid it is OK
 		 * if the network does broadcast and the user did set essid
@@ -2444,16 +2444,16 @@ inline int rtllib_rx_frame_softmac(struct rtllib_device *ieee,
 
 /* following are for a simplier TX queue management.
  * Instead of using netif_[stop/wake]_queue the driver
- * will uses these two function (plus a reset one), that
- * will internally uses the kernel netif_* and takes
+ * will use these two functions (plus a reset one), that
+ * will internally use the kernel netif_* and takes
  * care of the ieee802.11 fragmentation.
  * So the driver receives a fragment per time and might
- * call the stop function when it want without take care
- * to have enought room to TX an entire packet.
- * This might be useful if each fragment need it's own
+ * call the stop function when it wants to not
+ * have enough room to TX an entire packet.
+ * This might be useful if each fragment needs it's own
  * descriptor, thus just keep a total free memory > than
- * the max fragmentation treshold is not enought.. If the
- * ieee802.11 stack passed a TXB struct then you needed
+ * the max fragmentation threshold is not enough.. If the
+ * ieee802.11 stack passed a TXB struct then you need
  * to keep N free descriptors where
  * N = MAX_PACKET_SIZE / MIN_FRAG_TRESHOLD
  * In this way you need just one and the 802.11 stack
@@ -2696,15 +2696,15 @@ static void rtllib_start_ibss_wq(void *data)
 	rtllib_softmac_check_all_nets(ieee);
 
 
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
-	 * scan) beacause in ibss mode the rtllib_new_net function, when
+	 * scan) because in ibss mode the rtllib_new_net function, when
 	 * finds a good net, just set the ieee->state to RTLLIB_LINKED,
 	 * so, at worst, we waste a bit of time to initiate an unneeded syncro
 	 * scan, that will stop at the first round because it sees the state
@@ -2819,7 +2819,7 @@ void rtllib_start_bss(struct rtllib_device *ieee)
 
 	/* ensure no-one start an associating process (thus setting
 	 * the ieee->state to rtllib_ASSOCIATING) while we
-	 * have just cheked it and we are going to enable scan.
+	 * have just checked it and we are going to enable scan.
 	 * The rtllib_new_net function is always called with
 	 * lock held (from both rtllib_softmac_check_all_nets and
 	 * the rx path), so we cannot be in the middle of such function
@@ -2872,7 +2872,7 @@ static void rtllib_associate_retry_wq(void *data)
 
 	/* until we do not set the state to RTLLIB_NOLINK
 	* there are no possibility to have someone else trying
-	* to start an association procdure (we get here with
+	* to start an association procedure (we get here with
 	* ieee->state = RTLLIB_ASSOCIATING).
 	* When we set the state to RTLLIB_NOLINK it is possible
 	* that the RX path run an attempt to associate, but
diff --git a/drivers/staging/rtl8192e/rtllib_softmac_wx.c b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
index 1523bc7..1bb6b52 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
@@ -479,7 +479,7 @@ int rtllib_wx_set_essid(struct rtllib_device *ieee,
 
 
 	/* this is just to be sure that the GET wx callback
-	 * has consisten infos. not needed otherwise
+	 * has consistent infos. not needed otherwise
 	 */
 	spin_lock_irqsave(&ieee->lock, flags);
 
@@ -575,7 +575,7 @@ int rtllib_wx_set_power(struct rtllib_device *ieee,
 	if ((!ieee->sta_wake_up) ||
 	    (!ieee->enter_sleep_state) ||
 	    (!ieee->ps_is_queue_empty)) {
-		RTLLIB_DEBUG(RTLLIB_DL_ERR, "%s(): PS mode is tryied to be use "
+		RTLLIB_DEBUG(RTLLIB_DL_ERR, "%s(): PS mode is tried to be use "
 			     "but driver missed a callback\n\n", __func__);
 		return -1;
 	}
diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192e/rtllib_tx.c
index f451bfc..f24aa00c 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -59,7 +59,7 @@
 802.11 Data Frame
 
 
-802.11 frame_contorl for data frames - 2 bytes
+802.11 frame_control for data frames - 2 bytes
      ,-----------------------------------------------------------------------------------------.
 bits | 0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  a  |  b  |  c  |  d  |  e   |
      |----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|------|
@@ -576,7 +576,7 @@ int rtllib_xmit_inter(struct sk_buff *skb, struct net_device *dev)
 
 	spin_lock_irqsave(&ieee->lock, flags);
 
-	/* If there is no driver handler to take the TXB, dont' bother
+	/* If there is no driver handler to take the TXB, don't bother
 	 * creating it... */
 	if ((!ieee->hard_start_xmit && !(ieee->softmac_features &
 	   IEEE_SOFTMAC_TX_QUEUE)) ||
@@ -738,7 +738,7 @@ int rtllib_xmit_inter(struct sk_buff *skb, struct net_device *dev)
 		   (CFG_RTLLIB_COMPUTE_FCS | CFG_RTLLIB_RESERVE_FCS))
 			bytes_per_frag -= RTLLIB_FCS_LEN;
 
-		/* Each fragment may need to have room for encryptiong
+		/* Each fragment may need to have room for encrypting
 		 * pre/postfix */
 		if (encrypt) {
 			bytes_per_frag -= crypt->ops->extra_mpdu_prefix_len +
diff --git a/drivers/staging/rtl8192e/rtllib_wx.c b/drivers/staging/rtl8192e/rtllib_wx.c
index e5fe2e8..c7e8d4d8 100644
--- a/drivers/staging/rtl8192e/rtllib_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_wx.c
@@ -408,7 +408,7 @@ int rtllib_wx_set_encode(struct rtllib_device *ieee,
 				       (*crypt)->priv);
 		sec.flags |= (1 << key);
 		/* This ensures a key will be activated if no key is
-		 * explicitely set */
+		 * explicitly set */
 		if (key == sec.active_key)
 			sec.flags |= SEC_ACTIVE_KEY;
 		ieee->crypt_info.tx_keyidx = key;
-- 
1.7.5.4

