Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2B1Hmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:42:47 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:45907 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756172Ab2B1Hmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:42:46 -0500
From: Zhao Ye <zhaoy@marvell.com>
To: Zhao Ye <zhaoy@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>, Chao Xie <cxie4@marvell.com>,
        Leo Yan <leoy@marvell.com>
Date: Mon, 27 Feb 2012 23:42:34 -0800
Subject: RE: [PATCH 13/13] DMA:update defconfig for mmp2
Thread-Topic: [PATCH 13/13] DMA:update defconfig for mmp2
Thread-Index: Acz16pqZ6HWqwUfXRIO8SQtP/fgiqwAAa6Ug
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF1A0E95FF51@SC-VEXCH4.marvell.com>
References: <Y> <1330414065-2949-14-git-send-email-zhaoy@marvell.com>
In-Reply-To: <1330414065-2949-14-git-send-email-zhaoy@marvell.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1S7grUx025204

Sorry! Please ignore these patches. I will send a new version.

Best Regard
Zhao Ye
+61942433
Marvell Tech (SH) Co. Ltd.

-----Original Message-----
From: zhaoy [mailto:zhaoy@marvell.com] 
Sent: 2012Äê2ÔÂ28ÈÕ 15:28
To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; nicolas.pitre@linaro.org; linux@arm.linux.org.uk; Haojian Zhuang; Chao Xie; Leo Yan
Cc: Zhao Ye
Subject: [PATCH 13/13] DMA:update defconfig for mmp2

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

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
