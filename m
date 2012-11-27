Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2K0MJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:09:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49265 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2K0MJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:09:52 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 6/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
Date: Tue, 27 Nov 2012 21:09:46 +0900
Message-Id: <1354018186-18306-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
References: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: spaces required around that '=' (ctx:VxV)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index 177ff58..97faad9 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -337,7 +337,7 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
 			      union iwreq_data *wrqu, char *extra)
 {
 
-	int ret=0, len;
+	int ret = 0, len;
 	short proto_started;
 	unsigned long flags;
 
@@ -348,12 +348,12 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
 	proto_started = ieee->proto_started;
 
 	if (wrqu->essid.length > IW_ESSID_MAX_SIZE) {
-		ret= -E2BIG;
+		ret = -E2BIG;
 		goto out;
 	}
 
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
-		ret= -1;
+		ret = -1;
 		goto out;
 	}
 
@@ -528,7 +528,7 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
 				 struct iw_request_info *info,
 				 union iwreq_data *wrqu, char *extra)
 {
-	int ret =0;
+	int ret = 0;
 
 	down(&ieee->wx_sem);
 
-- 
1.7.9.5

