Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2A0QaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:30:08 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:57499 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752148Ab2A0QaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:30:06 -0500
From: Roland Stigge <stigge@antcom.de>
To: w.sang@pengutronix.de, grant.likely@secretlab.ca, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/2] Fix gpio-lpc32xx.c: Pin masking missing
Date: Fri, 27 Jan 2012 17:29:33 +0100
Message-Id: <1327681773-2395-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing mask to pin bit selection in gpio-lpc32xx.c
(#define GPIO3_PIN_IN_SEL)

A table indentation was necessary due to line length restrictions.

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index ddfacc5..21b65e5 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -26,42 +26,42 @@
 #include <mach/platform.h>
 #include <mach/gpio-lpc32xx.h>
 
-#define LPC32XX_GPIO_P3_INP_STATE		_GPREG(0x000)
-#define LPC32XX_GPIO_P3_OUTP_SET		_GPREG(0x004)
-#define LPC32XX_GPIO_P3_OUTP_CLR		_GPREG(0x008)
-#define LPC32XX_GPIO_P3_OUTP_STATE		_GPREG(0x00C)
-#define LPC32XX_GPIO_P2_DIR_SET			_GPREG(0x010)
-#define LPC32XX_GPIO_P2_DIR_CLR			_GPREG(0x014)
-#define LPC32XX_GPIO_P2_DIR_STATE		_GPREG(0x018)
-#define LPC32XX_GPIO_P2_INP_STATE		_GPREG(0x01C)
-#define LPC32XX_GPIO_P2_OUTP_SET		_GPREG(0x020)
-#define LPC32XX_GPIO_P2_OUTP_CLR		_GPREG(0x024)
-#define LPC32XX_GPIO_P2_MUX_SET			_GPREG(0x028)
-#define LPC32XX_GPIO_P2_MUX_CLR			_GPREG(0x02C)
-#define LPC32XX_GPIO_P2_MUX_STATE		_GPREG(0x030)
-#define LPC32XX_GPIO_P0_INP_STATE		_GPREG(0x040)
-#define LPC32XX_GPIO_P0_OUTP_SET		_GPREG(0x044)
-#define LPC32XX_GPIO_P0_OUTP_CLR		_GPREG(0x048)
-#define LPC32XX_GPIO_P0_OUTP_STATE		_GPREG(0x04C)
-#define LPC32XX_GPIO_P0_DIR_SET			_GPREG(0x050)
-#define LPC32XX_GPIO_P0_DIR_CLR			_GPREG(0x054)
-#define LPC32XX_GPIO_P0_DIR_STATE		_GPREG(0x058)
-#define LPC32XX_GPIO_P1_INP_STATE		_GPREG(0x060)
-#define LPC32XX_GPIO_P1_OUTP_SET		_GPREG(0x064)
-#define LPC32XX_GPIO_P1_OUTP_CLR		_GPREG(0x068)
-#define LPC32XX_GPIO_P1_OUTP_STATE		_GPREG(0x06C)
-#define LPC32XX_GPIO_P1_DIR_SET			_GPREG(0x070)
-#define LPC32XX_GPIO_P1_DIR_CLR			_GPREG(0x074)
-#define LPC32XX_GPIO_P1_DIR_STATE		_GPREG(0x078)
-
-#define GPIO012_PIN_TO_BIT(x)			(1 << (x))
-#define GPIO3_PIN_TO_BIT(x)			(1 << ((x) + 25))
-#define GPO3_PIN_TO_BIT(x)			(1 << (x))
-#define GPIO012_PIN_IN_SEL(x, y)		(((x) >> (y)) & 1)
-#define GPIO3_PIN_IN_SHIFT(x)			((x) == 5 ? 24 : 10 + (x))
-#define GPIO3_PIN_IN_SEL(x, y)			((x) >> GPIO3_PIN_IN_SHIFT(y))
-#define GPIO3_PIN5_IN_SEL(x)			(((x) >> 24) & 1)
-#define GPI3_PIN_IN_SEL(x, y)			(((x) >> (y)) & 1)
+#define LPC32XX_GPIO_P3_INP_STATE	_GPREG(0x000)
+#define LPC32XX_GPIO_P3_OUTP_SET	_GPREG(0x004)
+#define LPC32XX_GPIO_P3_OUTP_CLR	_GPREG(0x008)
+#define LPC32XX_GPIO_P3_OUTP_STATE	_GPREG(0x00C)
+#define LPC32XX_GPIO_P2_DIR_SET		_GPREG(0x010)
+#define LPC32XX_GPIO_P2_DIR_CLR		_GPREG(0x014)
+#define LPC32XX_GPIO_P2_DIR_STATE	_GPREG(0x018)
+#define LPC32XX_GPIO_P2_INP_STATE	_GPREG(0x01C)
+#define LPC32XX_GPIO_P2_OUTP_SET	_GPREG(0x020)
+#define LPC32XX_GPIO_P2_OUTP_CLR	_GPREG(0x024)
+#define LPC32XX_GPIO_P2_MUX_SET		_GPREG(0x028)
+#define LPC32XX_GPIO_P2_MUX_CLR		_GPREG(0x02C)
+#define LPC32XX_GPIO_P2_MUX_STATE	_GPREG(0x030)
+#define LPC32XX_GPIO_P0_INP_STATE	_GPREG(0x040)
+#define LPC32XX_GPIO_P0_OUTP_SET	_GPREG(0x044)
+#define LPC32XX_GPIO_P0_OUTP_CLR	_GPREG(0x048)
+#define LPC32XX_GPIO_P0_OUTP_STATE	_GPREG(0x04C)
+#define LPC32XX_GPIO_P0_DIR_SET		_GPREG(0x050)
+#define LPC32XX_GPIO_P0_DIR_CLR		_GPREG(0x054)
+#define LPC32XX_GPIO_P0_DIR_STATE	_GPREG(0x058)
+#define LPC32XX_GPIO_P1_INP_STATE	_GPREG(0x060)
+#define LPC32XX_GPIO_P1_OUTP_SET	_GPREG(0x064)
+#define LPC32XX_GPIO_P1_OUTP_CLR	_GPREG(0x068)
+#define LPC32XX_GPIO_P1_OUTP_STATE	_GPREG(0x06C)
+#define LPC32XX_GPIO_P1_DIR_SET		_GPREG(0x070)
+#define LPC32XX_GPIO_P1_DIR_CLR		_GPREG(0x074)
+#define LPC32XX_GPIO_P1_DIR_STATE	_GPREG(0x078)
+
+#define GPIO012_PIN_TO_BIT(x)		(1 << (x))
+#define GPIO3_PIN_TO_BIT(x)		(1 << ((x) + 25))
+#define GPO3_PIN_TO_BIT(x)		(1 << (x))
+#define GPIO012_PIN_IN_SEL(x, y)	(((x) >> (y)) & 1)
+#define GPIO3_PIN_IN_SHIFT(x)		((x) == 5 ? 24 : 10 + (x))
+#define GPIO3_PIN_IN_SEL(x, y)		(((x) >> GPIO3_PIN_IN_SHIFT(y)) & 1)
+#define GPIO3_PIN5_IN_SEL(x)		(((x) >> 24) & 1)
+#define GPI3_PIN_IN_SEL(x, y)		(((x) >> (y)) & 1)
 
 struct gpio_regs {
 	void __iomem *inp_state;
