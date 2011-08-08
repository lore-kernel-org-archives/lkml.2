Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1HHXSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:18:51 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:19281 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1HHXSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:18:50 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1312845528!27816223!9
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: gpio: ep93xx: remove unused inline function
Date: Mon, 8 Aug 2011 16:18:29 -0700
User-Agent: KMail/1.9.9
CC: <rmallon@gmail.com>, <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201108081618.30158.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 468b27d..e0ad8e0 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -62,11 +62,6 @@ static void ep93xx_gpio_update_int_params(unsigned port)
 		EP93XX_GPIO_REG(int_en_register_offset[port]));
 }
 
-static inline void ep93xx_gpio_int_mask(unsigned line)
-{
-	gpio_int_unmasked[line >> 3] &= ~(1 << (line & 7));
-}
-
 static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
 {
 	int line = irq_to_gpio(irq);
