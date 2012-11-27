Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2K0MJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:09:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49926 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2K0MJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:09:08 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
Date: Tue, 27 Nov 2012 21:09:02 +0900
Message-Id: <1354018142-18202-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
References: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: suspect code indent for conditional statements

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index 0b82c600..63524ca 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -69,9 +69,8 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
 
 		if (ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
 			if (ieee->state == IEEE80211_LINKED) {
-
-			ieee80211_stop_send_beacons(ieee);
-			ieee80211_start_send_beacons(ieee);
+				ieee80211_stop_send_beacons(ieee);
+				ieee80211_start_send_beacons(ieee);
 			}
 	}
 
@@ -219,9 +218,9 @@ int ieee80211_wx_set_rate(struct ieee80211_device *ieee,
 
 	//added by lizhaoming for auto mode
 	if (target_rate == -1) {
-	ieee->rate = 110;
+		ieee->rate = 110;
 	} else {
-	ieee->rate = target_rate/100000;
+		ieee->rate = target_rate/100000;
 	}
 	//FIXME: we might want to limit rate also in management protocols.
 	return 0;
-- 
1.7.9.5

