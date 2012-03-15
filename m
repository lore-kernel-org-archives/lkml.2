Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031629Ab2COP64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:58:56 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:19043 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031528Ab2COP6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:58:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com,
        herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 5/6] Input: Kconfig: remove dependency for atmel_tsadcc driver
Date: Thu, 15 Mar 2012 16:57:21 +0100
Message-Id: <531cf3ace390f3673a73792f15f9c7cd6aeb273d.1331826095.git.nicolas.ferre@atmel.com>
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
 drivers/input/touchscreen/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 4af2a18..3900c64 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -432,10 +432,10 @@ config TOUCHSCREEN_TOUCHWIN
 
 config TOUCHSCREEN_ATMEL_TSADCC
 	tristate "Atmel Touchscreen Interface"
-	depends on ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
+	depends on ARCH_AT91
 	help
 	  Say Y here if you have a 4-wire touchscreen connected to the
-          ADC Controller on your Atmel SoC (such as the AT91SAM9RL).
+          ADC Controller on your Atmel SoC.
 
 	  If unsure, say N.
 
-- 
1.7.9

