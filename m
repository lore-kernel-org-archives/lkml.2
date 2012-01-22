Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2AVSGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 13:06:42 -0500
Received: from antcom.de ([188.40.178.216]:34245 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2AVSGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 13:06:41 -0500
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jan 2012 13:06:41 EST
Message-ID: <4F1C4E25.6070801@antcom.de>
Date: Sun, 22 Jan 2012 18:57:57 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com
CC: Roland Stigge <stigge@antcom.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] Correct bad gpio naming
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the GPIO names in drivers/gpio/gpio-lpc32xx.c
was bad. Renaming gpi000 -> gpio00

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 5b69480..ddfacc5 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -96,7 +96,7 @@ static const char *gpio_p2_names[LPC32XX_GPIO_P2_MAX] = {
 };
  static const char *gpio_p3_names[LPC32XX_GPIO_P3_MAX] = {
-	"gpi000", "gpio01", "gpio02", "gpio03",
+	"gpio00", "gpio01", "gpio02", "gpio03",
 	"gpio04", "gpio05"
 };

