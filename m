Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2K2Nf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:35:57 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39318 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2K2Nfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:35:55 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/4] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_wx.c
Date: Thu, 29 Nov 2012 22:35:51 +0900
Message-Id: <1354196151-12109-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354196079-11726-1-git-send-email-yamanetoshi@gmail.com>
References: <1354196079-11726-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
-ERROR: spaces required around that '<' (ctx:VxV)
-ERROR: spaces required around that '?' (ctx:VxV)
-ERROR: spaces required around that ':' (ctx:VxV)
-ERROR: spaces required around that '>' (ctx:VxV)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index e37555b..9d46087 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -221,7 +221,7 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 		list_for_each_entry(network, &ieee->network_list, list) {
 			i++;
 
-			if ((stop-ev)<200) {
+			if ((stop-ev) < 200) {
 				err = -E2BIG;
 				break;
 			}
@@ -683,13 +683,13 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 		break;
 
 	case IW_AUTH_80211_AUTH_ALG:
-		ieee->open_wep = (data->value&IW_AUTH_ALG_OPEN_SYSTEM)?1:0;
+		ieee->open_wep = (data->value&IW_AUTH_ALG_OPEN_SYSTEM) ? 1 : 0;
 		//printk("open_wep:%d\n", ieee->open_wep);
 		break;
 
 #if 1
 	case IW_AUTH_WPA_ENABLED:
-		ieee->wpa_enabled = (data->value)?1:0;
+		ieee->wpa_enabled = (data->value) ? 1 : 0;
 		//printk("enable wpa:%d\n", ieee->wpa_enabled);
 		break;
 
@@ -711,7 +711,7 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 {
 	u8 *buf = NULL;
 
-	if (len>MAX_WPA_IE_LEN || (len && ie == NULL)) {
+	if (len > MAX_WPA_IE_LEN || (len && ie == NULL)) {
 		printk("return error out, len:%zu\n", len);
 	return -EINVAL;
 	}
-- 
1.7.9.5

