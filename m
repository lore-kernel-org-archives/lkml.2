Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2K1NUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:20:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42732 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab2K1NUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:20:31 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 5/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
Date: Wed, 28 Nov 2012 22:20:27 +0900
Message-Id: <1354108827-17694-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
References: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: "foo* bar" should be "foo *bar"

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index fb4b406..43e344a 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -292,7 +292,7 @@ static int ieee80211_is_eapol_frame(struct ieee80211_device *ieee,
 
 /* Called only as a tasklet (software IRQ), by ieee80211_rx */
 static inline int
-ieee80211_rx_frame_decrypt(struct ieee80211_device* ieee, struct sk_buff *skb,
+ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
 			   struct ieee80211_crypt_data *crypt)
 {
 	struct ieee80211_hdr_4addr *hdr;
@@ -337,7 +337,7 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device* ieee, struct sk_buff *skb,
 
 /* Called only as a tasklet (software IRQ), by ieee80211_rx */
 static inline int
-ieee80211_rx_frame_decrypt_msdu(struct ieee80211_device* ieee, struct sk_buff *skb,
+ieee80211_rx_frame_decrypt_msdu(struct ieee80211_device *ieee, struct sk_buff *skb,
 			     int keyidx, struct ieee80211_crypt_data *crypt)
 {
 	struct ieee80211_hdr_4addr *hdr;
@@ -841,7 +841,7 @@ static inline void ieee80211_extract_country_ie(
 	struct ieee80211_device *ieee,
 	struct ieee80211_info_element *info_element,
 	struct ieee80211_network *network,
-	u8 * addr2
+	u8 *addr2
 )
 {
 	if (IS_DOT11D_ENABLE(ieee)) {
@@ -1187,7 +1187,7 @@ inline int ieee80211_network_init(
 
 static inline int is_same_network(struct ieee80211_network *src,
 				  struct ieee80211_network *dst,
-				  struct ieee80211_device * ieee)
+				  struct ieee80211_device *ieee)
 {
 	/* A network is only a duplicate if the channel, BSSID, ESSID
 	 * and the capability field (in particular IBSS and BSS) all match.
-- 
1.7.9.5

