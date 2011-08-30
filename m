Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1H3ESc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:18:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60151 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1H3ES2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:18:28 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v3 06/18] Staging: cx25821: Fix wrong brace placement in cx25821-core.c
Date: Tue, 30 Aug 2011 12:17:01 +0800
Message-Id: <1314677833-4689-7-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix wrong brace placement in cx25821-core.c

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-core.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 26d2879..4382e45 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -69,7 +69,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .gpcnt = VID_DST_A_GPCNT,
 		       .vip_ctl = VID_DST_A_VIP_CTL,
 		       .pix_frmt = VID_DST_A_PIX_FRMT,
-		       },
+	},
 
 	[SRAM_CH01] = {
 		       .i = SRAM_CH01,
@@ -91,7 +91,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .gpcnt = VID_DST_B_GPCNT,
 		       .vip_ctl = VID_DST_B_VIP_CTL,
 		       .pix_frmt = VID_DST_B_PIX_FRMT,
-		       },
+	},
 
 	[SRAM_CH02] = {
 		       .i = SRAM_CH02,
@@ -113,7 +113,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .gpcnt = VID_DST_C_GPCNT,
 		       .vip_ctl = VID_DST_C_VIP_CTL,
 		       .pix_frmt = VID_DST_C_PIX_FRMT,
-		       },
+	},
 
 	[SRAM_CH03] = {
 		       .i = SRAM_CH03,
@@ -135,7 +135,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .gpcnt = VID_DST_D_GPCNT,
 		       .vip_ctl = VID_DST_D_VIP_CTL,
 		       .pix_frmt = VID_DST_D_PIX_FRMT,
-		       },
+	},
 
 	[SRAM_CH04] = {
 		       .i = SRAM_CH04,
@@ -157,7 +157,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .gpcnt = VID_DST_E_GPCNT,
 		       .vip_ctl = VID_DST_E_VIP_CTL,
 		       .pix_frmt = VID_DST_E_PIX_FRMT,
-		       },
+	},
 
 	[SRAM_CH05] = {
 		       .i = SRAM_CH05,
@@ -179,7 +179,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .gpcnt = VID_DST_F_GPCNT,
 		       .vip_ctl = VID_DST_F_VIP_CTL,
 		       .pix_frmt = VID_DST_F_PIX_FRMT,
-		       },
+	},
 
 	[SRAM_CH06] = {
 		       .i = SRAM_CH06,
@@ -201,7 +201,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .gpcnt = VID_DST_G_GPCNT,
 		       .vip_ctl = VID_DST_G_VIP_CTL,
 		       .pix_frmt = VID_DST_G_PIX_FRMT,
-		       },
+	},
 
 	[SRAM_CH07] = {
 		       .i = SRAM_CH07,
@@ -223,7 +223,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .gpcnt = VID_DST_H_GPCNT,
 		       .vip_ctl = VID_DST_H_VIP_CTL,
 		       .pix_frmt = VID_DST_H_PIX_FRMT,
-		       },
+	},
 
 	[SRAM_CH08] = {
 		       .name = "audio from",
@@ -236,7 +236,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .ptr2_reg = DMA17_PTR2,
 		       .cnt1_reg = DMA17_CNT1,
 		       .cnt2_reg = DMA17_CNT2,
-		       },
+	},
 
 	[SRAM_CH09] = {
 		       .i = SRAM_CH09,
@@ -262,7 +262,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .vid_active_ctl2 = VID_SRC_I_ACTIVE_CTL2,
 		       .vid_cdt_size = VID_SRC_I_CDT_SZ,
 		       .irq_bit = 8,
-		       },
+	},
 
 	[SRAM_CH10] = {
 		       .i = SRAM_CH10,
@@ -288,7 +288,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .vid_active_ctl2 = VID_SRC_J_ACTIVE_CTL2,
 		       .vid_cdt_size = VID_SRC_J_CDT_SZ,
 		       .irq_bit = 9,
-		       },
+	},
 
 	[SRAM_CH11] = {
 		       .i = SRAM_CH11,
@@ -313,7 +313,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .fld_aud_fifo_en = FLD_AUD_SRC_B_FIFO_EN,
 		       .fld_aud_risc_en = FLD_AUD_SRC_B_RISC_EN,
 		       .irq_bit = 11,
-		       },
+	},
 };
 EXPORT_SYMBOL(cx25821_sram_channels);
 
@@ -1480,10 +1480,10 @@ static DEFINE_PCI_DEVICE_TABLE(cx25821_pci_tbl) = {
 	 .device = 0x8210,
 	 .subvendor = 0x14f1,
 	 .subdevice = 0x0920,
-	 },
+	},
 	{
 	 /* --- end of list --- */
-	 }
+	}
 };
 
 MODULE_DEVICE_TABLE(pci, cx25821_pci_tbl);
-- 
1.7.0.4

