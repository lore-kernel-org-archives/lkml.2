Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1FNKwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:52:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52567 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab1FNKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:52:14 -0400
Message-ID: <4DF73D20.20700@ru.mvista.com>
Date: Tue, 14 Jun 2011 14:51:12 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?0JTQtdC90LjRgSDQmtGD0LfRjNC80LXQvdC60L4=?= 
	<dart@solonet.org.ua>
CC: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm mach-s3c2440 mach-mini2440: New LCD-W35i support
References: <BANLkTikfLQH=_tSMkFGB7Jx_4vUKPmn-3w@mail.gmail.com>
In-Reply-To: <BANLkTikfLQH=_tSMkFGB7Jx_4vUKPmn-3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-06-2011 1:21, Денис Кузьменко wrote:

> From: Denis Kuzmenko <dart@solonet.org.ua>

    Need an empty line here...

> LCD-W35i support for Mini2440 development board

> --- linux-2.6.39.1/arch/arm/mach-s3c2440/mach-mini2440.c
> 2011-06-03 03:34:20.000000000 +0300
> +++ linux-2.6.39.1-dart/arch/arm/mach-s3c2440/mach-mini2440.c
> 2011-06-13 23:37:38.785984118 +0300
> @@ -167,6 +167,20 @@ static struct s3c2410fb_display mini2440
>                  .lcdcon5        = (S3C2410_LCDCON5_FRM565 |
>                                     S3C2410_LCDCON5_HWSWP),
>          },
> +       /* LCD-W35i 3.5" display (LQ035Q1DG06)*/
> +       [3] = {
> +               _LCD_DECLARE(
> +                       7,              /* clock */
> +                       320, 68, 66, 4, /* xres, margin_right,
> margin_left, hsync */
> +                       240, 4, 4, 9,   /* yres, margin_top,
> margin_bottom, vsync */

    Your patch is line wrapped. Seems easy to fix though...

WBR, Sergei
