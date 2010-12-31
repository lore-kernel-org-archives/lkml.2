Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab0LaGC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 01:02:27 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:55059 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0LaGC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 01:02:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=chVivR0ncFsCMrJxdX3mk7zGuXCI6h26JDZe3bV6WvKQ+jz4CNje49cTPy65pLn0hK
         MzRMF4fbGL3VPDg22tNM4x6Z4w6J5QWX1+EVYSr0P9xRUXtcSmZVBIFmNvkpI2vGyePt
         qAHBwfOTsWRnSdBlriZ3DDb9EU7+EEgS1ge0s=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 14/15]drivers:staging:rtl8187se:ieee80211:ieee80211_softmac.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:50 -0800
Message-Id: <1293774531-5294-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-14-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-7-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-8-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-9-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-10-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-11-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-12-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-13-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-14-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   58 ++++++++++----------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 652d879..e945e88 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -42,7 +42,7 @@ short ieee80211_is_shortslot(struct ieee80211_network net)
 	return (net.capability & WLAN_CAPABILITY_SHORT_SLOT);
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
+/* place the MFIE rate, tag to the memory(double) pointed.
  * Then it updates the pointer so that
  * it points after the new MFIE tag added.
  */
@@ -152,7 +152,7 @@ void enqueue_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb)
 
 /*
  * if the queue is full but we have newer frames then
- * just overwrites the oldest.
+ * just overwrite the oldest.
  *
  * if (nh == ieee->mgmt_queue_tail)
  *		return -1;
@@ -456,8 +456,8 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 		}while(!channel_map[ch]);
 		/* this function can be called in two situations
 		 * 1- We have switched to ad-hoc mode and we are
-		 *    performing a complete syncro scan before conclude
-		 *    there are no interesting cell and to create a
+		 *    performing a complete syncro scan before concluding
+		 *    there are no interesting cell's and to create a
 		 *    new one. In this case the link state is
 		 *    IEEE80211_NOLINK until we found an interesting cell.
 		 *    If so the ieee8021_new_net, called by the RX path
@@ -465,12 +465,12 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 		 *    scanning
 		 * 2- We are linked and the root uses run iwlist scan.
 		 *    So we switch to IEEE80211_LINKED_SCANNING to remember
-		 *    that we are still logically linked (not interested in
+		 *    that we are still logically linked(not interested in
 		 *    new network events, despite for updating the net list,
 		 *    but we are temporarly 'unlinked' as the driver shall
-		 *    not filter RX frames and the channel is changing.
+		 *    not filter RX frames and the channel is changing).
 		 * So the only situation in witch are interested is to check
-		 * if the state become LINKED because of the #1 situation
+		 * if the state becomes LINKED because of the #1 situation
 		 */
 
 		if (ieee->state == IEEE80211_LINKED)
@@ -483,7 +483,7 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 //			printk("====send probe request\n");
 			ieee80211_send_probe_requests(ieee);
 		}
-		/* this prevent excessive time wait when we
+		/* this prevents excessive time wait when we
 		 * need to wait for a syncro scan to end..
 		 */
 		if (ieee->sync_scan_hurryup)
@@ -519,8 +519,8 @@ void ieee80211_softmac_ips_scan_syncro(struct ieee80211_device *ieee)
         {
                 /* this function can be called in two situations
                  * 1- We have switched to ad-hoc mode and we are
-                 *    performing a complete syncro scan before conclude
-                 *    there are no interesting cell and to create a
+                 *    performing a complete syncro scan before concluding
+                 *    there are no interesting cells and to create a
                  *    new one. In this case the link state is
                  *    IEEE80211_NOLINK until we found an interesting cell.
                  *    If so the ieee8021_new_net, called by the RX path
@@ -528,10 +528,10 @@ void ieee80211_softmac_ips_scan_syncro(struct ieee80211_device *ieee)
                  *    scanning
                  * 2- We are linked and the root uses run iwlist scan.
                  *    So we switch to IEEE80211_LINKED_SCANNING to remember
-                 *    that we are still logically linked (not interested in
+                 *    that we are still logically linked(not interested in
                  *    new network events, despite for updating the net list,
                  *    but we are temporarly 'unlinked' as the driver shall
-                 *    not filter RX frames and the channel is changing.
+                 *    not filter RX frames and the channel is changing).
                  * So the only situation in witch are interested is to check
                  * if the state become LINKED because of the #1 situation
                  */
@@ -549,7 +549,7 @@ void ieee80211_softmac_ips_scan_syncro(struct ieee80211_device *ieee)
 //			printk("====send probe request\n");
 			ieee80211_send_probe_requests(ieee);
                 }
-		/* this prevent excessive time wait when we
+		/* this prevents excessive time wait when we
                  * need to wait for a syncro scan to end..
                  */
 //                if (ieee->sync_scan_hurryup)
@@ -1314,7 +1314,7 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
 
 	short apset,ssidset,ssidbroad,apmatch,ssidmatch;
 
-	/* we are interested in new new only if we are not associated
+	/* we are interested in new only if we are not associated
 	 * and we are not associating / authenticating
 	 */
 	if (ieee->state != IEEE80211_NOLINK)
@@ -1955,16 +1955,16 @@ associate_complete:
 
 /* following are for a simplier TX queue management.
  * Instead of using netif_[stop/wake]_queue the driver
- * will uses these two function (plus a reset one), that
- * will internally uses the kernel netif_* and takes
+ * will use these two functions (plus a reset one), that
+ * will internally use the kernel netif_* and takes
  * care of the ieee802.11 fragmentation.
  * So the driver receives a fragment per time and might
- * call the stop function when it want without take care
- * to have enough room to TX an entire packet.
- * This might be useful if each fragment need it's own
+ * call the stop function when it does not have enough
+ * room to TX an entire packet.
+ * This might be useful if each fragment needs it's own
  * descriptor, thus just keep a total free memory > than
  * the max fragmentation threshold is not enough.. If the
- * ieee802.11 stack passed a TXB struct then you needed
+ * ieee802.11 stack passed a TXB struct then you need
  * to keep N free descriptors where
  * N = MAX_PACKET_SIZE / MIN_FRAG_TRESHOLD
  * In this way you need just one and the 802.11 stack
@@ -2183,13 +2183,13 @@ void ieee80211_start_ibss_wq(struct work_struct *work)
 
 	if(ieee->state == IEEE80211_NOLINK)
 		ieee->current_network.channel = 10;
-	/* if not then the state is not linked. Maybe the user swithced to
+	/* if not then the state is not linked. Maybe the user switched to
 	 * ad-hoc mode just after being in monitor mode, or just after
-	 * being very few time in managed mode (so the card have had no
+	 * being short period of time in managed mode (so the card has had no
 	 * time to scan all the chans..) or we have just run up the iface
 	 * after setting ad-hoc mode. So we have to give another try..
 	 * Here, in ibss mode, should be safe to do this without extra care
-	 * (in bss mode we had to make sure no-one tryed to associate when
+	 * (in bss mode we had to make sure no-one tried to associate when
 	 * we had just checked the ieee->state and we was going to start the
 	 * scan) beacause in ibss mode the ieee80211_new_net function, when
 	 * finds a good net, just set the ieee->state to IEEE80211_LINKED,
@@ -2340,15 +2340,15 @@ void ieee80211_associate_retry_wq(struct work_struct *work)
 	if(ieee->state != IEEE80211_ASSOCIATING_RETRY)
 		goto exit;
 	/* until we do not set the state to IEEE80211_NOLINK
-	* there are no possibility to have someone else trying
-	* to start an association procdure (we get here with
+	* there is no possibility to have someone else trying
+	* to start an association procedure (we get here with
 	* ieee->state = IEEE80211_ASSOCIATING).
 	* When we set the state to IEEE80211_NOLINK it is possible
 	* that the RX path run an attempt to associate, but
 	* both ieee80211_softmac_check_all_nets and the
 	* RX path works with ieee->lock held so there are no
 	* problems. If we are still disassociated then start a scan.
-	* the lock here is necessary to ensure no one try to start
+	* the lock here is necessary to ensure no one tries to start
 	* an association procedure when we have just checked the
 	* state and we are going to start the scan.
 	*/
@@ -2484,8 +2484,8 @@ void ieee80211_start_protocol(struct ieee80211_device *ieee)
 
 
 	/* if the user set the MAC of the ad-hoc cell and then
-	 * switch to managed mode, shall we  make sure that association
-	 * attempts does not fail just because the user provide the essid
+	 * switch to managed mode, shall we make sure that association
+	 * attempts does not fail just because the user provides the essid
 	 * and the nic is still checking for the AP MAC ??
 	 */
 	switch (ieee->iw_mode) {
-- 
1.6.5.2.180.gc5b3e

