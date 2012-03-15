Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031600Ab2COP6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:58:44 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:4941 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031490Ab2COP6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:58:39 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com,
        herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/6] rtc: Kconfig: remove dependency for AT91 rtc driver
Date: Thu, 15 Mar 2012 16:57:20 +0100
Message-Id: <7dce7bba2113315bf484570e3e0ad234c68c610b.1331826095.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow to select this driver for newer SoCs.
Keep dependency on AT91 because of the use of an header
file located in include/mach directory.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/rtc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 3a125b8..918736e 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -831,7 +831,7 @@ config RTC_DRV_AT32AP700X
 
 config RTC_DRV_AT91RM9200
 	tristate "AT91RM9200 or some AT91SAM9 RTC"
-	depends on ARCH_AT91RM9200 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
+	depends on ARCH_AT91
 	help
 	  Driver for the internal RTC (Realtime Clock) module found on
 	  Atmel AT91RM9200's and some  AT91SAM9 chips. On AT91SAM9 chips
-- 
1.7.9

