Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1LLWLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:11:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39499 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1LLWLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:11:36 -0500
Message-ID: <4EE67C0F.10900@gmail.com>
Date: Tue, 13 Dec 2011 09:11:27 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'H Hartley Sweeten'" <hsweeten@visionengravers.com>
Subject: Re: [PATCH] backlight: ep93xx_bl: remove duplicated header include
References: <001201ccb8a2$ca235e30$5e6a1a90$%han@samsung.com>
In-Reply-To: <001201ccb8a2$ca235e30$5e6a1a90$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 18:51, Jingoo Han wrote:

> This patch removes duplicated module header for EP93xx backlight
> driver.
> drivers/video/backlight/ep93xx_bl.c: module.h is included more
> than once.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/ep93xx_bl.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
> index c74a6f4..4893dff 100644
> --- a/drivers/video/backlight/ep93xx_bl.c
> +++ b/drivers/video/backlight/ep93xx_bl.c
> @@ -10,10 +10,8 @@
>   * This driver controls the pulse width modulated brightness control output,
>   * BRIGHT, on the Cirrus EP9307, EP9312, and EP9315 processors.
>   */
> -


Please don't remove the blank line between the header comment and the
first include.

~Ryan

>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> -#include <linux/module.h>
>  #include <linux/io.h>
>  #include <linux/fb.h>
>  #include <linux/backlight.h>


