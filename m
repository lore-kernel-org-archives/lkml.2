Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1GGI3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:29:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50358 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1GGI3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:29:05 -0400
MIME-Version: 1.0
In-Reply-To: <e5bfdcabc4041d24277a2453ecc2690072cfdacf.1309997525.git.joe@perches.com>
References: <e9742e1fca57477517fdb6ea110221d6292eed9c.1309997525.git.joe@perches.com>
 <e5bfdcabc4041d24277a2453ecc2690072cfdacf.1309997525.git.joe@perches.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 7 Jul 2011 16:28:44 +0800
Message-ID: <CAMPhdO_ifW8ivha+_AOo-oNhTMuwGzLrQYP2r-q6iQUp+fb20Q@mail.gmail.com>
Subject: Re: [PATCH next 2/2] MAINTAINERS: Update PXA2xx/PXA3xx SUPPORT patterns
To: Joe Perches <joe@perches.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 8:28 AM, Joe Perches <joe@perches.com> wrote:
> commit ca632f556697 ("spi: reorganize drivers")
> renamed the files, update the MAINTAINERS patterns.
>
> cc: Grant Likely <grant.likely@secretlab.ca>
> cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> cc: Wan ZongShun <mcuos.com@gmail.com>
> cc: Eric Miao <eric.y.miao@gmail.com>
> cc: Russell King <linux@arm.linux.org.uk>
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0ad8ff0..4e5cc19 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1123,7 +1123,7 @@ F:        drivers/watchdog/nuc900_wdt.c
>  F:     drivers/net/arm/w90p910_ether.c
>  F:     drivers/mtd/nand/nuc900_nand.c
>  F:     drivers/rtc/rtc-nuc900.c
> -F:     drivers/spi/spi_nuc900.c
> +F:     drivers/spi/spi-nuc900.c
>  F:     drivers/usb/host/ehci-w90x900.c
>  F:     drivers/video/nuc900fb.c
>
> @@ -1321,7 +1321,7 @@ F:        drivers/net/macb.*
>  ATMEL SPI DRIVER
>  M:     Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:     Supported
> -F:     drivers/spi/atmel_spi.*
> +F:     drivers/spi/spi-atmel.c
>
>  ATMEL USBA UDC DRIVER
>  M:     Nicolas Ferre <nicolas.ferre@atmel.com>
> @@ -5142,7 +5142,7 @@ L:        linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:     Maintained
>  F:     arch/arm/mach-pxa/
>  F:     drivers/pcmcia/pxa2xx*
> -F:     drivers/spi/pxa2xx*
> +F:     drivers/spi/spi-pxa2xx*
>  F:     drivers/usb/gadget/pxa2*
>  F:     include/sound/pxa2xx-lib.h
>  F:     sound/arm/pxa*
> --
> 1.7.6.131.g99019
>
>
