Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2IYH4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:56:45 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:30990 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753520Ab2IYH4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:56:44 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/2] gpio-lpc32xx: Add GPI_28
Date: Tue, 25 Sep 2012 09:56:13 +0200
Message-Id: <1348559774-15484-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing gpi28 to the list of GPIOs in the GPI P3 "chip".

NOTE: This patch depends on incrementing LPC32XX_GPI_P3_MAX.  When applied
without the respective mach-lpc32xx patch (merged via arm-soc.git), gcc will
give a warning about "excess elements in array initializer" but this doesn't
harm.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h |    2 +-
 drivers/gpio/gpio-lpc32xx.c                       |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
+++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
@@ -113,7 +113,8 @@ static const char *gpi_p3_names[LPC32XX_
 	 NULL,    NULL,    NULL,   "gpi15",
 	"gpi16", "gpi17", "gpi18", "gpi19",
 	"gpi20", "gpi21", "gpi22", "gpi23",
-	"gpi24", "gpi25", "gpi26", "gpi27"
+	"gpi24", "gpi25", "gpi26", "gpi27",
+	"gpi28"
 };
 
 static const char *gpo_p3_names[LPC32XX_GPO_P3_MAX] = {
