Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2BFORU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:17:20 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:35527
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752184Ab2BFORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:17:19 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: tony@atomide.com, linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mach-omap1: Fix typo in lcd_dma.c
Date: Mon,  6 Feb 2012 23:16:44 +0900
Message-Id: <1328537804-1916-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "resulotion" to "resolution" in
arch/arm/mach-omap1/lcd_dma.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-omap1/lcd_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/lcd_dma.c b/arch/arm/mach-omap1/lcd_dma.c
index 4538093..4c5ce7d 100644
--- a/arch/arm/mach-omap1/lcd_dma.c
+++ b/arch/arm/mach-omap1/lcd_dma.c
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(omap_set_lcd_dma_b1_mirror);
 void omap_set_lcd_dma_b1_vxres(unsigned long vxres)
 {
 	if (cpu_is_omap15xx()) {
-		printk(KERN_ERR "DMA virtual resulotion is not supported "
+		printk(KERN_ERR "DMA virtual resolution is not supported "
 				"in 1510 mode\n");
 		BUG();
 	}
-- 
1.7.6.5

