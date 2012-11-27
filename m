Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2K0MJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:09:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49926 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2K0MJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:09:37 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 5/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
Date: Tue, 27 Nov 2012 21:09:31 +0900
Message-Id: <1354018171-18271-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
References: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following wanings fixed.
- WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index f06ed35..177ff58 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -218,11 +218,11 @@ int ieee80211_wx_set_rate(struct ieee80211_device *ieee,
 	u32 target_rate = wrqu->bitrate.value;
 
 	//added by lizhaoming for auto mode
-	if (target_rate == -1) {
+	if (target_rate == -1)
 		ieee->rate = 110;
-	} else {
+	else
 		ieee->rate = target_rate/100000;
-	}
+
 	//FIXME: we might want to limit rate also in management protocols.
 	return 0;
 }
@@ -250,12 +250,10 @@ int ieee80211_wx_set_mode(struct ieee80211_device *ieee, struct iw_request_info
 	if (wrqu->mode == ieee->iw_mode)
 		goto out;
 
-	if (wrqu->mode == IW_MODE_MONITOR) {
-
+	if (wrqu->mode == IW_MODE_MONITOR)
 		ieee->dev->type = ARPHRD_IEEE80211;
-	} else {
+	else
 		ieee->dev->type = ARPHRD_ETHER;
-	}
 
 	if (!ieee->proto_started) {
 		ieee->iw_mode = wrqu->mode;
-- 
1.7.9.5

