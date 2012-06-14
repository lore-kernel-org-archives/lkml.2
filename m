Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2FNQvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:52 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:55750 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932137Ab2FNQvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:36 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 08/23] ARM: LPC32xx: Clock adjustment for key matrix controller
Date: Thu, 14 Jun 2012 18:50:58 +0200
Message-Id: <1339692673-7848-9-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock.c file needs to be changed to match the automatic device name to its
clock.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Rob Herring <rob.herring@calxeda.com>

---
 arch/arm/mach-lpc32xx/clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -1131,7 +1131,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_INIT("31020300.i2c", NULL, &clk_i2c2),
 	CLKDEV_INIT("dev:ssp0", NULL, &clk_ssp0),
 	CLKDEV_INIT("dev:ssp1", NULL, &clk_ssp1),
-	CLKDEV_INIT("lpc32xx_keys.0", NULL, &clk_kscan),
+	CLKDEV_INIT("40050000.key", NULL, &clk_kscan),
 	CLKDEV_INIT("20020000.flash", NULL, &clk_nand),
 	CLKDEV_INIT("200a8000.flash", NULL, &clk_nand_mlc),
 	CLKDEV_INIT("40048000.adc", NULL, &clk_adc),
