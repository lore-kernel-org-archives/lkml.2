Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab1HIXNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 19:13:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60813 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1HIXNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 19:13:44 -0400
From: Kolymine <kolymine@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kolymine <kolymine@gmail.com>
Subject: [PATCH] Staging : winbond : fix coding style issue in phy_calibration.c
Date: Wed, 10 Aug 2011 01:13:38 +0200
Message-Id: <1312931618-14470-1-git-send-email-kolymine@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <Staging-winbond-fix>
References: <Staging-winbond-fix>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thus us a patch to the phy_calibration.c file that fixes up coding style warning found by the checkpatch.pl tool

Signed-off-by: Vincent Abel-Grimalt <kolymine@gmail.com>
---
 drivers/staging/winbond/phy_calibration.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index c5a07fb..77a3fff 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -24,7 +24,7 @@
 
 #define AG_CONST        0.6072529350
 #define FIXED(X)        ((s32)((X) * 32768.0))
-#define DEG2RAD(X)      0.017453 * (X)
+#define DEG2RAD(X)      (0.017453 * (X))
 
 static const s32 Angles[] = {
 	FIXED(DEG2RAD(45.0)),     FIXED(DEG2RAD(26.565)),   FIXED(DEG2RAD(14.0362)),
@@ -51,7 +51,7 @@ s32 _s13_to_s32(u32 data)
 	if ((data & BIT(12)) != 0)
 		val |= 0xFFFFF000;
 
-	return ((s32) val);
+	return (s32) val;
 }
 
 u32 _s32_to_s13(s32 data)
@@ -184,7 +184,7 @@ s32 _floor(s32 n)
 	else
 		n -= 5;
 
-	return (n/10);
+	return n/10;
 }
 
 /****************************************************************************/
@@ -455,7 +455,7 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 	phy_set_rf_data(phw_data, 11, (11<<24)|0x1901D6);
 	/* 0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized */
 	phy_set_rf_data(phw_data, 5, (5<<24)|0x24C48A);
-        /* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
+	/* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
 	phy_set_rf_data(phw_data, 6, (6<<24)|0x06890C);
 	/* 0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode */
 	phy_set_rf_data(phw_data, 0, (0<<24)|0xFDF1C0);
@@ -577,7 +577,7 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 	phy_set_rf_data(phw_data, 11, (11<<24)|0x1901D6);
 	/* 0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized */
 	phy_set_rf_data(phw_data, 5, (5<<24)|0x24C48A);
-        /* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
+	/* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
 	phy_set_rf_data(phw_data, 6, (6<<24)|0x06890C);
 	/* 0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode */
 	phy_set_rf_data(phw_data, 0, (0<<24)|0xFDF1C0);
@@ -974,7 +974,7 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 	phy_set_rf_data(phw_data, 11, (11<<24)|0x19BDD6); /* 20060612.1.a 0x1905D6); */
 	/* 0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized */
 	phy_set_rf_data(phw_data, 5, (5<<24)|0x24C60A); /* 0x24C60A (high temperature) */
-        /* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
+	/* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
 	phy_set_rf_data(phw_data, 6, (6<<24)|0x34880C); /* 20060612.1.a 0x06890C); */
 	/* 0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode */
 	phy_set_rf_data(phw_data, 0, (0<<24)|0xFDF1C0);
-- 
1.7.4.1

