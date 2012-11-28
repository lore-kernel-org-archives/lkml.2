Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2K1NTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:19:17 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48591 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2K1NTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:19:13 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
Date: Wed, 28 Nov 2012 22:19:05 +0900
Message-Id: <1354108745-17592-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
References: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: suspect code indent for conditional statements

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |   56 ++++++++++----------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index ef8bfab..c932e31 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -108,17 +108,17 @@ ieee80211_frag_cache_get(struct ieee80211_device *ieee,
 	u8 tid;
 
 	if (((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
-	  hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
-	  tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
-	  tid = UP2AC(tid);
-	  tid ++;
+		hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
+		tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
+		tid = UP2AC(tid);
+		tid ++;
 	} else if (IEEE80211_QOS_HAS_SEQ(fc)) {
-	  hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)hdr;
-	  tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
-	  tid = UP2AC(tid);
-	  tid ++;
+		hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)hdr;
+		tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
+		tid = UP2AC(tid);
+		tid ++;
 	} else {
-	  tid = 0;
+		tid = 0;
 	}
 
 	if (frag == 0) {
@@ -175,17 +175,17 @@ static int ieee80211_frag_cache_invalidate(struct ieee80211_device *ieee,
 	u8 tid;
 
 	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
-	  hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
-	  tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
-	  tid = UP2AC(tid);
-	  tid ++;
+		hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
+		tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
+		tid = UP2AC(tid);
+		tid ++;
 	} else if (IEEE80211_QOS_HAS_SEQ(fc)) {
-	  hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)hdr;
-	  tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
-	  tid = UP2AC(tid);
-	  tid ++;
+		hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)hdr;
+		tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
+		tid = UP2AC(tid);
+		tid ++;
 	} else {
-	  tid = 0;
+		tid = 0;
 	}
 
 	entry = ieee80211_frag_cache_find(ieee, seq, -1, tid,hdr->addr2,
@@ -382,17 +382,17 @@ static int is_duplicate_packet(struct ieee80211_device *ieee,
 
 	//TO2DS and QoS
 	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
-	  hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)header;
-	  tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
-	  tid = UP2AC(tid);
-	  tid ++;
+		hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)header;
+		tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
+		tid = UP2AC(tid);
+		tid ++;
 	} else if(IEEE80211_QOS_HAS_SEQ(fc)) { //QoS
-	  hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)header;
-	  tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
-	  tid = UP2AC(tid);
-	  tid ++;
+		hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)header;
+		tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
+		tid = UP2AC(tid);
+		tid ++;
 	} else { // no QoS
-	  tid = 0;
+		tid = 0;
 	}
 	switch (ieee->iw_mode) {
 	case IW_MODE_ADHOC:
@@ -1309,7 +1309,7 @@ inline void update_network(struct ieee80211_network *dst,
 	   src->wmm_param[1].ac_aci_acm_aifsn|| \
 	   src->wmm_param[2].ac_aci_acm_aifsn|| \
 	   src->wmm_param[3].ac_aci_acm_aifsn) {
-	  memcpy(dst->wmm_param, src->wmm_param, WME_AC_PRAM_LEN);
+		memcpy(dst->wmm_param, src->wmm_param, WME_AC_PRAM_LEN);
 	}
 	dst->QoS_Enable = src->QoS_Enable;
 #else
-- 
1.7.9.5

