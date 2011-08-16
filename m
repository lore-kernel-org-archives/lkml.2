Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1HPA0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:26:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43957 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1HPA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:26:00 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Akshay Joshi <me@akshayjoshi.com>,
        Chihau Chau <chihau@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] Staging: Winbond: Use tabs instead of spaces for indents.
Date: Mon, 15 Aug 2011 20:24:34 -0400
Message-Id: <1313454275-5604-8-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace some space indented lines with tab indented lines to follow the
kernel code style.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/phy_calibration.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 816fe7c..155f29d 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
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
1.7.5.4

