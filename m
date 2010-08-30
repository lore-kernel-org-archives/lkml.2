Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0H3LrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:47:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48549 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab0H3LrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:47:19 -0400
Date: Mon, 30 Aug 2010 20:47:08 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH 1/3] ARM: Samsung S5P: Move the common Samsung S5P series	GPIO
 level type
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org,
        kgene.kim@samsung.com
Message-id: <20100830114708.GA13140@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 30 Aug 2010 11:47:17.0053 (UTC)
 FILETIME=[187026D0:01CB4839]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Samsung S5P series has common level type. It's different from S3C series.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-samsung/include/plat/gpio-core.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/gpio-core.h b/arch/arm/plat-samsung/include/plat/gpio-core.h
index e358c7d..c8681e0 100644
--- a/arch/arm/plat-samsung/include/plat/gpio-core.h
+++ b/arch/arm/plat-samsung/include/plat/gpio-core.h
@@ -14,6 +14,12 @@
 #define GPIOCON_OFF	(0x00)
 #define GPIODAT_OFF	(0x04)
 
+#define S5P_GPIO_LEVEL_LOW		(0x00)
+#define S5P_GPIO_LEVEL_HIGH		(0x01)
+#define S5P_GPIO_EDGE_FALLING		(0x02)
+#define S5P_GPIO_EDGE_RISING		(0x03)
+#define S5P_GPIO_EDGE_BOTH		(0x04)
+
 #define con_4bit_shift(__off) ((__off) * 4)
 
 /* Define the core gpiolib support functions that the s3c platforms may
-- 
1.5.3.3

