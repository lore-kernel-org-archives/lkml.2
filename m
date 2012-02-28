Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2B1H3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:29:08 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:60279 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932351Ab2B1H3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:29:02 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 13/13] DMA:update defconfig for mmp2
Date: Tue, 28 Feb 2012 15:27:45 +0800
Message-Id: <1330414065-2949-14-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:44.0673 (UTC) FILETIME=[9A4C0F10:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.open DMAC and TDMA config in mmp2 defconfig

Change-Id: Ie253d527e481f376edf4cc5e56fbad7a7da4fefa
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 arch/arm/configs/mmp2_defconfig |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/configs/mmp2_defconfig b/arch/arm/configs/mmp2_defconfig
index 138c95a..b975779 100644
--- a/arch/arm/configs/mmp2_defconfig
+++ b/arch/arm/configs/mmp2_defconfig
@@ -1919,8 +1919,25 @@ CONFIG_RTC_DRV_MAX8925=y
 #
 # on-CPU RTC drivers
 #
-CONFIG_RTC_DRV_MMP=y
-# CONFIG_DMADEVICES is not set
+# CONFIG_RTC_DRV_MMP is not set
+CONFIG_DMADEVICES=y
+# CONFIG_DMADEVICES_DEBUG is not set
+
+#
+# DMA Devices
+#
+# CONFIG_DW_DMAC is not set
+# CONFIG_TIMB_DMA is not set
+CONFIG_PXA_DMAC=y
+CONFIG_MMP_TDMA=y
+CONFIG_DMA_ENGINE=y
+
+#
+# DMA Clients
+#
+# CONFIG_NET_DMA is not set
+# CONFIG_ASYNC_TX_DMA is not set
+# CONFIG_DMATEST is not set
 # CONFIG_AUXDISPLAY is not set
 CONFIG_UIO=y
 # CONFIG_UIO_PDRV is not set
-- 
1.7.0.4

