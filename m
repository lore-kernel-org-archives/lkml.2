Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab2B1H27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:28:59 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:51821 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756314Ab2B1H24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:56 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 11/13] DMA:update defconfig for mmp3
Date: Tue, 28 Feb 2012 15:27:43 +0800
Message-Id: <1330414065-2949-12-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:36.0673 (UTC) FILETIME=[95875B10:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.open DMAC and TDMA config in defconfig

Change-Id: I78876368e43472fe6e86314c438b98e518cfcb87
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 arch/arm/configs/mmp3_defconfig |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/mmp3_defconfig b/arch/arm/configs/mmp3_defconfig
index 4f8b160..3a363f4 100644
--- a/arch/arm/configs/mmp3_defconfig
+++ b/arch/arm/configs/mmp3_defconfig
@@ -2038,7 +2038,24 @@ CONFIG_RTC_INTF_ALARM_DEV=y
 # on-CPU RTC drivers
 #
 CONFIG_RTC_DRV_MMP=y
-# CONFIG_DMADEVICES is not set
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

