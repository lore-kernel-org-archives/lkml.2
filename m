Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab2DQHAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:00:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2DQHAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:00:00 -0400
Date: Tue, 17 Apr 2012 08:59:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        cjb@laptop.org
Subject: Re: [PATCH] mmc: cd-gpio.c: Include header to pickup exported symbol
 prototypes
In-Reply-To: <201204161824.26879.hartleys@visionengravers.com>
Message-ID: <Pine.LNX.4.64.1204170847490.27075@axis700.grange>
References: <201204161824.26879.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Cm1jxmgxL9qW+hnf0yd/VbeMe1TvQIgauoUEnDITqte
 oFtWJeHXiB3vvm0DSv91gs1kpl0dAeTbo4ELyzwFab7sK9PpaD
 Off/Qk5QbASBWPeqepFc5JfwUX/6K3fvB7m5iz2bNwnG9jV+xO
 0mWjCZA+P3vZ/khgOor7eYbxJmBCUDyEuLzO7sEH7/tphlDaXN
 4zdYuux0Jdhk8v8kDQmxDMQtck9Z1axzmf+vjo6vtKw4/BkbZ2
 YpZ8Re5jnwfuuU2J3x/hxb0c2XpqtYIhsyGq1qsIXtE8xlRUj4
 jR1ms9dRX2vyvAuVPEws9w3tr8SAQGuWvvvjMuEZ659paz1DW9
 KfS7ql1vpbcdLHYjVvdSnfhQWfrmkJkRMqDvnmlTjnHeNvzaxu
 9Kjk8kz6yFOBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hartley

Thanks for the patch.

On Mon, 16 Apr 2012, H Hartley Sweeten wrote:

> Include the linux/mmc/cd-gpio.h header to pickup the prototypes
> for the two exported symbols.
> 
> This quiets the sparse warnings:
> 
> warning: symbol 'mmc_cd_gpio_request' was not declared. Should it be static?
> warning: symbol 'mmc_cd_gpio_free' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> ---
> 
> diff --git a/drivers/mmc/core/cd-gpio.c b/drivers/mmc/core/cd-gpio.c
> index 29de31e..da7c3f9 100644
> --- a/drivers/mmc/core/cd-gpio.c
> +++ b/drivers/mmc/core/cd-gpio.c
> @@ -13,6 +13,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/jiffies.h>
>  #include <linux/mmc/host.h>
> +#include <linux/mmc/cd-gpio.h>

Call me a pettyfogger, but please put the header above mmc/host.h, please, 
keep the alphabetic order.

>  #include <linux/module.h>
>  #include <linux/slab.h>
>  

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
