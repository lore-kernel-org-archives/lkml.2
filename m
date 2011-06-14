Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1FNUeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 16:34:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65313 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1FNUeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 16:34:08 -0400
Message-ID: <4DF7C50A.7060602@solonet.org.ua>
Date: Tue, 14 Jun 2011 23:31:06 +0300
From: Denis Kuzmenko <list@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm mach-s3c2440 mach-mini2440: New LCD-W35i support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/14 Sergei Shtylyov <sshtylyov@mvista.com>

>   Need an empty line here...
>   Your patch is line wrapped. Seems easy to fix though...


Thank you. Is the patch below okay?

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
