Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab0HKXkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:40:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751761Ab0HKXjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:39:41 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18wbwo/FsQww2ESnbIH4x7VLuSBEfm6jSjK1M9t1E
	F2FzERGbnBGlLi
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 03/11] viafb: remove stub
Date: Wed, 11 Aug 2010 23:49:32 +0000
Message-Id: <1281570580-8253-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove stub

This is a nop so removing it is safe.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/hw.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 53b0651..63b6722 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -720,7 +720,6 @@ static struct rgbLUT palLUT_table[] = {
 
 static void set_crt_output_path(int set_iga);
 static void dvi_patch_skew_dvp0(void);
-static void dvi_patch_skew_dvp1(void);
 static void dvi_patch_skew_dvp_low(void);
 static void set_dvi_output_path(int set_iga, int output_interface);
 static void set_lcd_output_path(int set_iga, int output_interface);
@@ -910,21 +909,6 @@ static void dvi_patch_skew_dvp0(void)
 	}
 }
 
-static void dvi_patch_skew_dvp1(void)
-{
-	switch (viaparinfo->chip_info->gfx_chip_name) {
-	case UNICHROME_CX700:
-		{
-			break;
-		}
-
-	default:
-		{
-			break;
-		}
-	}
-}
-
 static void dvi_patch_skew_dvp_low(void)
 {
 	switch (viaparinfo->chip_info->gfx_chip_name) {
@@ -992,7 +976,6 @@ static void set_dvi_output_path(int set_iga, int output_interface)
 		}
 
 		viafb_write_reg_mask(SR1E, VIASR, 0x30, BIT4 + BIT5);
-		dvi_patch_skew_dvp1();
 		break;
 	case INTERFACE_DFP_HIGH:
 		if (viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266) {
-- 
1.6.3.2

