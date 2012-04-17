Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2DQISM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:18:12 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35962 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab2DQISJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <201204161824.26879.hartleys@visionengravers.com>
References: <201204161824.26879.hartleys@visionengravers.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Tue, 17 Apr 2012 13:47:46 +0530
Message-ID: <CANfBPZ_AhMpgX5L+Z62LekBLnsFytLAJi9pN6fRPcujh95iK+A@mail.gmail.com>
Subject: Re: [PATCH] mmc: cd-gpio.c: Include header to pickup exported symbol prototypes
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        cjb@laptop.org, g.liakhovetski@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 6:54 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
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
I posted a similar patch on friday. But yours has a more verbose commit log.
Acked-by: Venkatraman S <svenkatr@ti.com>

> ---
>
> diff --git a/drivers/mmc/core/cd-gpio.c b/drivers/mmc/core/cd-gpio.c
> index 29de31e..da7c3f9 100644
> --- a/drivers/mmc/core/cd-gpio.c
> +++ b/drivers/mmc/core/cd-gpio.c
> @@ -13,6 +13,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/jiffies.h>
>  #include <linux/mmc/host.h>
> +#include <linux/mmc/cd-gpio.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
