Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2HAVGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 17:06:01 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:57123 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab2HAVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:05:59 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: =?iso-8859-1?q?M=E1rton_N=E9meth?= <nm127@freemail.hu>
Subject: [PATCH 2/2] leds-clevo-mail: Fix Clevo M5x0V DMI strings
Date: Wed, 1 Aug 2012 23:04:56 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201208012304.56859.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are more variants of Clevo M5x0V laptops and Positivo Mobile is just one of them.
Another one is UMAX VisionBook 2400WXC. Use only generic Clevo DMI strings to match all
variants.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/leds/leds-clevo-mail.c
+++ b/drivers/leds/leds-clevo-mail.c
@@ -59,11 +59,10 @@ static struct dmi_system_id __initdata clevo_mail_led_dmi_table[] = {
 	},
 	{
 		.callback = clevo_mail_led_dmi_callback,
-		.ident = "Positivo Mobile",
+		.ident = "Clevo M5x0V",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "CLEVO Co. "),
 			DMI_MATCH(DMI_BOARD_NAME, "M5X0V "),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Positivo Mobile"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "VT6198")
 		}
 	},




-- 
Ondrej Zary
