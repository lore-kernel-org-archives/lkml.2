Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0LTKsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:48:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38922 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab0LTKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:48:51 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        liu.y.victor@gmail.com, B02280@freescale.com,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 8/9] ARM i.MX5: increase dma consistent size for IPU support
Date: Mon, 20 Dec 2010 11:48:46 +0100
Message-Id: <1292842127-21406-9-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/plat-mxc/include/mach/memory.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
index 9a9a000..987b42a 100644
--- a/arch/arm/plat-mxc/include/mach/memory.h
+++ b/arch/arm/plat-mxc/include/mach/memory.h
@@ -40,7 +40,8 @@
 # endif
 #endif
 
-#if defined(CONFIG_MX3_VIDEO)
+#if defined(CONFIG_MX3_VIDEO) || defined(CONFIG_MFD_IMX_IPU_V3) || \
+	defined(CONFIG_MFD_IMX_IPU_V3_MODULE)
 /*
  * Increase size of DMA-consistent memory region.
  * This is required for mx3 camera driver to capture at least two QXGA frames.
-- 
1.7.2.3

