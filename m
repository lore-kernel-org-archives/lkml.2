Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2K3NA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:00:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50841 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab2K3NA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:00:58 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/3] staging/rtl8187se: Fix spacing coding style in ieee80211/dot11d.c
Date: Fri, 30 Nov 2012 22:00:52 +0900
Message-Id: <1354280452-25365-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: spaces required around that '=' (ctx:VxV)
- ERROR: spaces required around that '<=' (ctx:VxV)
- ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/dot11d.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/dot11d.c b/drivers/staging/rtl8187se/ieee80211/dot11d.c
index 0e93eb0..247916b 100644
--- a/drivers/staging/rtl8187se/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8187se/ieee80211/dot11d.c
@@ -39,10 +39,10 @@ Dot11d_Reset(struct ieee80211_device *ieee)
 	memset(pDot11dInfo->channel_map, 0, MAX_CHANNEL_NUMBER+1);
 	memset(pDot11dInfo->MaxTxPwrDbmList, 0xFF, MAX_CHANNEL_NUMBER+1);
 	// Set new channel map
-	for (i=1; i<=11; i++) {
+	for (i = 1; i <= 11; i++) {
 		(pDot11dInfo->channel_map)[i] = 1;
 	}
-	for (i=12; i<=14; i++) {
+	for (i = 12; i <= 14; i++) {
 		(pDot11dInfo->channel_map)[i] = 2;
 	}
 
@@ -116,7 +116,7 @@ Dot11d_UpdateCountryIe(
 #if 1
 	//printk("Dot11d_UpdateCountryIe(): Channel List:\n");
 	printk("Channel List:");
-	for(i=1; i<= MAX_CHANNEL_NUMBER; i++)
+	for(i = 1; i <= MAX_CHANNEL_NUMBER; i++)
 		if(pDot11dInfo->channel_map[i] > 0)
 			printk(" %d", i);
 	printk("\n");
@@ -125,7 +125,7 @@ Dot11d_UpdateCountryIe(
 	UPDATE_CIE_SRC(dev, pTaddr);
 
 	pDot11dInfo->CountryIeLen = CoutryIeLen;
-	memcpy(pDot11dInfo->CountryIeBuf, pCoutryIe,CoutryIeLen);
+	memcpy(pDot11dInfo->CountryIeBuf, pCoutryIe, CoutryIeLen);
 	pDot11dInfo->State = DOT11D_STATE_LEARNED;
 }
 
@@ -202,7 +202,7 @@ int ToLegalChannel(
 	u8 default_chn = 0;
 	u32 i = 0;
 
-	for (i=1; i<= MAX_CHANNEL_NUMBER; i++)
+	for (i = 1; i <= MAX_CHANNEL_NUMBER; i++)
 	{
 		if(pDot11dInfo->channel_map[i] > 0)
 		{
-- 
1.7.9.5

