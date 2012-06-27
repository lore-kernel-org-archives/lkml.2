Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2F0WJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:09:47 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:44520 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751587Ab2F0WJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:09:46 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND] gpio: LPC32xx: Driver cleanup
Date: Thu, 28 Jun 2012 00:09:35 +0200
Message-Id: <1340834975-17144-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since LPC32xx is now switched over to devicetree based GPIO, the unused
lpc32xx_gpio_init() can be removed.

Further, the driver title changed since it referred to the wrong file.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

---
Applies to v3.5-rc4

 drivers/gpio/gpio-lpc32xx.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
+++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-lpc32xx/gpiolib.c
+ * GPIO driver for LPC32xx SoC
  *
  * Author: Kevin Wells <kevin.wells@nxp.com>
  *
@@ -457,13 +457,6 @@ static struct lpc32xx_gpio_chip lpc32xx_
 	},
 };
 
-/* Empty now, can be removed later when mach-lpc32xx is finally switched over
- * to DT support
- */
-void __init lpc32xx_gpio_init(void)
-{
-}
-
 static int lpc32xx_of_xlate(struct gpio_chip *gc,
 			    const struct of_phandle_args *gpiospec, u32 *flags)
 {
