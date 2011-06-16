Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab1FPLfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:35:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:57097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954Ab1FPLfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:35:43 -0400
Message-ID: <4DF9EA45.3020101@ru.mvista.com>
Date: Thu, 16 Jun 2011 15:34:29 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Denis Kuzmenko <list@solonet.org.ua>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm mach-s3c2440 mach-mini2440: New LCD-W35i support
References: <4DF7C50A.7060602@solonet.org.ua>
In-Reply-To: <4DF7C50A.7060602@solonet.org.ua>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 16 Jun 2011 11:35:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-06-2011 0:31, Denis Kuzmenko wrote:

>> Need an empty line here...
>> Your patch is line wrapped. Seems easy to fix though...

> Thank you. Is the patch below okay?

    Not yet. :-)

> From: Denis Kuzmenko <dart@solonet.org.ua>

> LCD-W35i support for Mini2440 development board

    Your signoff needs to be here. Sorry -- didn't notice the first time.

> --- linux-2.6.39.1/arch/arm/mach-s3c2440/mach-mini2440.c 2011-06-03
> 03:34:20.000000000 +0300
> +++ linux-2.6.39.1-dart/arch/arm/mach-s3c2440/mach-mini2440.c 2011-06-13
> 23:37:38.785984118 +0300
> @@ -167,6 +167,20 @@ static struct s3c2410fb_display mini2440
> .lcdcon5 = (S3C2410_LCDCON5_FRM565 |
> S3C2410_LCDCON5_HWSWP),
> },
> + /* LCD-W35i 3.5" display (LQ035Q1DG06)*/
> + [3] = {
> + _LCD_DECLARE(
> + 7, /* clock */
> + 320, 68, 66, 4, /* xres, margin_right, margin_left, hsync */
> + 240, 4, 4, 9, /* yres, margin_top, margin_bottom, vsync */
> + 60), /* refresh rate */
> + .lcdcon5 = (S3C2410_LCDCON5_FRM565 |
> + S3C2410_LCDCON5_INVVDEN |
> + S3C2410_LCDCON5_INVVFRAME |
> + S3C2410_LCDCON5_INVVLINE |
> + S3C2410_LCDCON5_INVVCLK |
> + S3C2410_LCDCON5_HWSWP),
> + },
> };

    The patch has all tabs converted to spaces. Didn't notice it the first 
time as well... :-/

WBR, Sergei
