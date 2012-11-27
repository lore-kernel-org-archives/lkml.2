Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2K0MKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:10:08 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41024 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2K0MKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:10:06 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 7/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
Date: Tue, 27 Nov 2012 21:10:00 +0900
Message-Id: <1354018200-18340-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
References: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following wanings fixed.
- WARNING: please, no spaces at the start of a line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index 97faad9..c71fb63 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -174,7 +174,7 @@ out:
 	return ret;
 }
 
- int ieee80211_wx_get_essid(struct ieee80211_device *ieee, struct iw_request_info *a,
+int ieee80211_wx_get_essid(struct ieee80211_device *ieee, struct iw_request_info *a,
 			    union iwreq_data *wrqu, char *b)
 {
 	int len, ret = 0;
@@ -395,7 +395,7 @@ out:
 	return ret;
 }
 
- int ieee80211_wx_get_mode(struct ieee80211_device *ieee, struct iw_request_info *a,
+int ieee80211_wx_get_mode(struct ieee80211_device *ieee, struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
 {
 
@@ -403,7 +403,7 @@ out:
 	return 0;
 }
 
- int ieee80211_wx_set_rawtx(struct ieee80211_device *ieee,
+int ieee80211_wx_set_rawtx(struct ieee80211_device *ieee,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-- 
1.7.9.5

