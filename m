Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2F0W13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:27:29 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:55281 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932231Ab2F0W1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:27:22 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 8/8] ARM: LPC32xx: Remove unused gpios
Date: Thu, 28 Jun 2012 00:26:18 +0200
Message-Id: <1340835978-20331-9-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1340835978-20331-1-git-send-email-stigge@antcom.de>
References: <1340835978-20331-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Remove SPI0_CS, MMC_CD and MMC_WP gpios as they moved to devicetree.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/phy3250.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -51,12 +51,9 @@
 /*
  * Mapped GPIOLIB GPIOs
  */
-#define SPI0_CS_GPIO		LPC32XX_GPIO(LPC32XX_GPIO_P3_GRP, 5)
 #define LCD_POWER_GPIO		LPC32XX_GPIO(LPC32XX_GPO_P3_GRP, 0)
 #define BKL_POWER_GPIO		LPC32XX_GPIO(LPC32XX_GPO_P3_GRP, 4)
 #define MMC_PWR_ENABLE_GPIO	LPC32XX_GPIO(LPC32XX_GPO_P3_GRP, 5)
-#define MMC_CD_GPIO		LPC32XX_GPIO(LPC32XX_GPIO_P3_GRP, 1)
-#define MMC_WP_GPIO		LPC32XX_GPIO(LPC32XX_GPIO_P3_GRP, 0)
 
 /*
  * AMBA LCD controller
