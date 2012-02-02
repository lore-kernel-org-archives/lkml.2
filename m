Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2BBTVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:21:07 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:56404 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933360Ab2BBTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:20:59 -0500
From: stigge@antcom.de
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v3 2/7] ARM: LPC32XX: Remove broken non-static declaration
Date: Thu,  2 Feb 2012 20:19:43 +0100
Message-Id: <1328210388-21296-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328210388-21296-1-git-send-email-stigge@antcom.de>
References: <1328210388-21296-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a GCC compile error ("static declaration follows non-static
declaration") for LPC32XX's watchdog, removing the extern declaration since
it's not called externally.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>

diff --git a/arch/arm/mach-lpc32xx/common.h b/arch/arm/mach-lpc32xx/common.h
index 4b4e700..75640bfb 100644
--- a/arch/arm/mach-lpc32xx/common.h
+++ b/arch/arm/mach-lpc32xx/common.h
@@ -65,7 +65,6 @@ extern u32 clk_get_pclk_div(void);
  */
 extern void lpc32xx_get_uid(u32 devid[4]);
 
-extern void lpc32xx_watchdog_reset(void);
 extern u32 lpc32xx_return_iram_size(void);
 
 /*
