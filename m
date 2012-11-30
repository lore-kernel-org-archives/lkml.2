Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab2K3NBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:01:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60438 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2K3NBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:01:48 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/3] staging/rtl8187se: Fix spacing coding style in ieee80211/dot11d.c
Date: Fri, 30 Nov 2012 22:01:37 +0900
Message-Id: <1354280497-25589-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354280452-25365-1-git-send-email-yamanetoshi@gmail.com>
References: <1354280452-25365-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: "foo * bar" should be "foo *bar"
- ERROR: "(foo*)" should be "(foo *)"

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/dot11d.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/dot11d.c b/drivers/staging/rtl8187se/ieee80211/dot11d.c
index b61a66d..9d2d5c5 100644
--- a/drivers/staging/rtl8187se/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8187se/ieee80211/dot11d.c
@@ -67,9 +67,9 @@ Dot11d_Reset(struct ieee80211_device *ieee)
 void
 Dot11d_UpdateCountryIe(
 	struct ieee80211_device *dev,
-	u8 *		pTaddr,
+	u8 *pTaddr,
 	u16	CoutryIeLen,
-	u8 * pCoutryIe
+	u8 *pCoutryIe
 	)
 {
 	PRT_DOT11D_INFO pDot11dInfo = GET_DOT11D_INFO(dev);
@@ -107,7 +107,7 @@ Dot11d_UpdateCountryIe(
 			MaxChnlNum = pTriple->FirstChnl + j;
 		}
 
-		pTriple = (PCHNL_TXPOWER_TRIPLE)((u8*)pTriple + 3);
+		pTriple = (PCHNL_TXPOWER_TRIPLE)((u8 *)pTriple + 3);
 	}
 #if 1
 	//printk("Dot11d_UpdateCountryIe(): Channel List:\n");
@@ -148,7 +148,7 @@ DOT11D_GetMaxTxPwrInDbm(
 
 void
 DOT11D_ScanComplete(
-	struct ieee80211_device * dev
+	struct ieee80211_device *dev
 	)
 {
 	PRT_DOT11D_INFO pDot11dInfo = GET_DOT11D_INFO(dev);
@@ -170,7 +170,7 @@ DOT11D_ScanComplete(
 }
 
 int IsLegalChannel(
-	struct ieee80211_device * dev,
+	struct ieee80211_device *dev,
 	u8 channel
 )
 {
@@ -186,7 +186,7 @@ int IsLegalChannel(
 }
 
 int ToLegalChannel(
-	struct ieee80211_device * dev,
+	struct ieee80211_device *dev,
 	u8 channel
 )
 {
-- 
1.7.9.5

