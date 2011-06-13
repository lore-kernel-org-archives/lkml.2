Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1FMVWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:22:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40880 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1FMVWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:22:04 -0400
MIME-Version: 1.0
X-Originating-IP: [195.42.130.215]
From: =?UTF-8?B?0JTQtdC90LjRgSDQmtGD0LfRjNC80LXQvdC60L4=?= 
	<dart@solonet.org.ua>
Date: Tue, 14 Jun 2011 00:21:42 +0300
Message-ID: <BANLkTikfLQH=_tSMkFGB7Jx_4vUKPmn-3w@mail.gmail.com>
Subject: [PATCH] arm mach-s3c2440 mach-mini2440: New LCD-W35i support
To: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?B?0JTQtdC90LjRgSDQmtGD0LfRjNC80LXQvdC60L4=?= 
	<dart@solonet.org.ua>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Kuzmenko <dart@solonet.org.ua>
LCD-W35i support for Mini2440 development board

--- linux-2.6.39.1/arch/arm/mach-s3c2440/mach-mini2440.c
2011-06-03 03:34:20.000000000 +0300
+++ linux-2.6.39.1-dart/arch/arm/mach-s3c2440/mach-mini2440.c
2011-06-13 23:37:38.785984118 +0300
@@ -167,6 +167,20 @@ static struct s3c2410fb_display mini2440
                .lcdcon5        = (S3C2410_LCDCON5_FRM565 |
                                   S3C2410_LCDCON5_HWSWP),
        },
+       /* LCD-W35i 3.5" display (LQ035Q1DG06)*/
+       [3] = {
+               _LCD_DECLARE(
+                       7,              /* clock */
+                       320, 68, 66, 4, /* xres, margin_right,
margin_left, hsync */
+                       240, 4, 4, 9,   /* yres, margin_top,
margin_bottom, vsync */
+                       60),            /* refresh rate */
+               .lcdcon5        = (S3C2410_LCDCON5_FRM565 |
+                                  S3C2410_LCDCON5_INVVDEN |
+                                  S3C2410_LCDCON5_INVVFRAME |
+                                  S3C2410_LCDCON5_INVVLINE |
+                                  S3C2410_LCDCON5_INVVCLK |
+                                  S3C2410_LCDCON5_HWSWP),
+       },
 };

 /* todo - put into gpio header */
