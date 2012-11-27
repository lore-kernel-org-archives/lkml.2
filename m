Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2K0MJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:09:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49926 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2K0MJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:09:21 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 4/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
Date: Tue, 27 Nov 2012 21:09:16 +0900
Message-Id: <1354018156-18237-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
References: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: space prohibited after that ',' (ctx:WxW)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index 63524ca..f06ed35 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -174,9 +174,10 @@ out:
 	return ret;
 }
 
- int ieee80211_wx_get_essid(struct ieee80211_device *ieee, struct iw_request_info *a,union iwreq_data *wrqu,char *b)
+ int ieee80211_wx_get_essid(struct ieee80211_device *ieee, struct iw_request_info *a,
+			    union iwreq_data *wrqu, char *b)
 {
-	int len,ret = 0;
+	int len, ret = 0;
 	unsigned long flags;
 
 	if (ieee->iw_mode == IW_MODE_MONITOR)
@@ -199,7 +200,7 @@ out:
 	}
 	len = ieee->current_network.ssid_len;
 	wrqu->essid.length = len;
-	strncpy(b,ieee->current_network.ssid,len);
+	strncpy(b, ieee->current_network.ssid, len);
 	wrqu->essid.flags = 1;
 
 out:
@@ -338,7 +339,7 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
 			      union iwreq_data *wrqu, char *extra)
 {
 
-	int ret=0,len;
+	int ret=0, len;
 	short proto_started;
 	unsigned long flags;
 
@@ -454,9 +455,9 @@ int ieee80211_wx_get_name(struct ieee80211_device *ieee,
 
 	if ((ieee->state == IEEE80211_LINKED) ||
 		(ieee->state == IEEE80211_LINKED_SCANNING))
-		strlcat(wrqu->name,"  link", IFNAMSIZ);
+		strlcat(wrqu->name, "  link", IFNAMSIZ);
 	else if (ieee->state != IEEE80211_NOLINK)
-		strlcat(wrqu->name," .....", IFNAMSIZ);
+		strlcat(wrqu->name, " .....", IFNAMSIZ);
 
 
 	return 0;
@@ -508,7 +509,7 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
 	if (wrqu->power.flags & IW_POWER_TIMEOUT) {
 
 		ieee->ps_timeout = wrqu->power.value / 1000;
-		printk("Timeout %d\n",ieee->ps_timeout);
+		printk("Timeout %d\n", ieee->ps_timeout);
 	}
 
 	if (wrqu->power.flags & IW_POWER_PERIOD) {
-- 
1.7.9.5

