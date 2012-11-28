Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2K1NVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:21:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54423 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab2K1NVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:21:12 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 8/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
Date: Wed, 28 Nov 2012 22:21:07 +0900
Message-Id: <1354108867-17796-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
References: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: please, no spaces at the start of a line
- WARNING: please, no space before tabs

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |   34 ++++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 7534d20..446f15e 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -793,7 +793,7 @@ static inline int ieee80211_is_ofdm_rate(u8 rate)
 	case IEEE80211_OFDM_RATE_54MB:
 		return 1;
 	}
-        return 0;
+	return 0;
 }
 
 static inline int ieee80211_SignalStrengthTranslate(
@@ -884,7 +884,7 @@ inline int ieee80211_network_init(
 	char *p;
 #endif
 	struct ieee80211_info_element *info_element;
- 	u16 left;
+	u16 left;
 	u8 i;
 	short offset;
 	u8 curRate = 0, hOpRate = 0, curRate_ex = 0;
@@ -917,10 +917,10 @@ inline int ieee80211_network_init(
 	} else
 		network->flags |= NETWORK_HAS_CCK;
 
- 	network->wpa_ie_len = 0;
- 	network->rsn_ie_len = 0;
+	network->wpa_ie_len = 0;
+	network->rsn_ie_len = 0;
 
- 	info_element = &beacon->info_element;
+	info_element = &beacon->info_element;
 	left = stats->len - ((void *)info_element - (void *)beacon);
 	while (left >= sizeof(struct ieee80211_info_element_hdr)) {
 		if (sizeof(struct ieee80211_info_element_hdr) + info_element->len > left) {
@@ -928,7 +928,7 @@ inline int ieee80211_network_init(
 					     info_element->len + sizeof(struct ieee80211_info_element),
 					     left);
 			return 1;
-               	}
+		}
 
 		switch (info_element->id) {
 		case MFIE_TYPE_SSID:
@@ -941,8 +941,8 @@ inline int ieee80211_network_init(
 			network->ssid_len = min(info_element->len,
 						(u8)IW_ESSID_MAX_SIZE);
 			memcpy(network->ssid, info_element->data, network->ssid_len);
-        		if (network->ssid_len < IW_ESSID_MAX_SIZE)
-                		memset(network->ssid + network->ssid_len, 0,
+			if (network->ssid_len < IW_ESSID_MAX_SIZE)
+				memset(network->ssid + network->ssid_len, 0,
 				       IW_ESSID_MAX_SIZE - network->ssid_len);
 
 			IEEE80211_DEBUG_SCAN("MFIE_TYPE_SSID: '%s' len=%d.\n",
@@ -1002,14 +1002,14 @@ inline int ieee80211_network_init(
 			break;
 
 		case MFIE_TYPE_DS_SET:
-  			IEEE80211_DEBUG_SCAN("MFIE_TYPE_DS_SET: %d\n",
+			IEEE80211_DEBUG_SCAN("MFIE_TYPE_DS_SET: %d\n",
 					     info_element->data[0]);
 			if (stats->freq == IEEE80211_24GHZ_BAND)
 				network->channel = info_element->data[0];
 			break;
 
-	 	case MFIE_TYPE_FH_SET:
-  			IEEE80211_DEBUG_SCAN("MFIE_TYPE_FH_SET: ignored\n");
+		case MFIE_TYPE_FH_SET:
+			IEEE80211_DEBUG_SCAN("MFIE_TYPE_FH_SET: ignored\n");
 			break;
 
 		case MFIE_TYPE_CF_SET:
@@ -1137,14 +1137,14 @@ inline int ieee80211_network_init(
 		default:
 			IEEE80211_DEBUG_SCAN("unsupported IE %d\n",
 					     info_element->id);
-                        break;
-  		}
+			break;
+		}
 
 		left -= sizeof(struct ieee80211_info_element_hdr) +
 			info_element->len;
 		info_element = (struct ieee80211_info_element *)
-                	&info_element->data[info_element->len];
-  	}
+			&info_element->data[info_element->len];
+	}
 //by amy 080312
 	network->HighestOperaRate = hOpRate;
 //by amy 080312
@@ -1204,8 +1204,8 @@ inline void update_network(struct ieee80211_network *dst,
 	unsigned char quality = src->stats.signalstrength;
 	unsigned char signal = 0;
 	unsigned char noise = 0;
-        if (dst->stats.signalstrength > 0)
-                quality = (dst->stats.signalstrength * 5 + src->stats.signalstrength + 5)/6;
+	if (dst->stats.signalstrength > 0)
+		quality = (dst->stats.signalstrength * 5 + src->stats.signalstrength + 5)/6;
 	signal = ieee80211_TranslateToDbm(quality);
 	//noise = signal - src->stats.noise;
 	if (dst->stats.noise > 0)
-- 
1.7.9.5

