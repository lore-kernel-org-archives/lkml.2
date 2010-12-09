Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0LINrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:47:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42251 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab0LINr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:47:29 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 8/9] ARM i.MX5: increase dma consistent size for IPU support
Date: Thu,  9 Dec 2010 14:47:20 +0100
Message-Id: <1291902441-24712-9-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/plat-mxc/include/mach/memory.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
index 9a9a000..a8152db 100644
--- a/arch/arm/plat-mxc/include/mach/memory.h
+++ b/arch/arm/plat-mxc/include/mach/memory.h
@@ -40,7 +40,7 @@
 # endif
 #endif
 
-#if defined(CONFIG_MX3_VIDEO)
+#if defined(CONFIG_MX3_VIDEO) || defined(CONFIG_MFD_IMX_IPU_V3)
 /*
  * Increase size of DMA-consistent memory region.
  * This is required for mx3 camera driver to capture at least two QXGA frames.
-- 
1.7.2.3

