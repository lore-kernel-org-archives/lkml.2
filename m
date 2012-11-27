Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2K0MH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:07:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53705 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2K0MH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:07:57 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
Date: Tue, 27 Nov 2012 21:07:45 +0900
Message-Id: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: space prohibited after that '&' (ctx:WxW)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index 1ef8fd6..f38519e 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -32,7 +32,7 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
 			     union iwreq_data *wrqu, char *b)
 {
 	int ret;
-	struct iw_freq *fwrq = & wrqu->freq;
+	struct iw_freq *fwrq = &wrqu->freq;
 //	printk("in %s\n",__func__);
 	down(&ieee->wx_sem);
 
@@ -86,7 +86,7 @@ int ieee80211_wx_get_freq(struct ieee80211_device *ieee,
 			     struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
 {
-	struct iw_freq *fwrq = & wrqu->freq;
+	struct iw_freq *fwrq = &wrqu->freq;
 
 	if (ieee->current_network.channel == 0)
 		return -1;
-- 
1.7.9.5

