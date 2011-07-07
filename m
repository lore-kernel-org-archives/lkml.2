Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1GGHIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:08:19 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27736 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1GGHIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:08:17 -0400
Message-ID: <4E155B45.7080408@atmel.com>
Date: Thu, 07 Jul 2011 09:07:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Wan ZongShun <mcuos.com@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH next 2/2] MAINTAINERS: Update PXA2xx/PXA3xx SUPPORT patterns
References: <e9742e1fca57477517fdb6ea110221d6292eed9c.1309997525.git.joe@perches.com> <e5bfdcabc4041d24277a2453ecc2690072cfdacf.1309997525.git.joe@perches.com>
In-Reply-To: <e5bfdcabc4041d24277a2453ecc2690072cfdacf.1309997525.git.joe@perches.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/07/2011 02:28, Joe Perches :
> commit ca632f556697 ("spi: reorganize drivers")
> renamed the files, update the MAINTAINERS patterns.
> 
> cc: Grant Likely <grant.likely@secretlab.ca>
> cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> cc: Wan ZongShun <mcuos.com@gmail.com>
> cc: Eric Miao <eric.y.miao@gmail.com>
> cc: Russell King <linux@arm.linux.org.uk>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0ad8ff0..4e5cc19 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1123,7 +1123,7 @@ F:	drivers/watchdog/nuc900_wdt.c
>  F:	drivers/net/arm/w90p910_ether.c
>  F:	drivers/mtd/nand/nuc900_nand.c
>  F:	drivers/rtc/rtc-nuc900.c
> -F:	drivers/spi/spi_nuc900.c
> +F:	drivers/spi/spi-nuc900.c
>  F:	drivers/usb/host/ehci-w90x900.c
>  F:	drivers/video/nuc900fb.c
>  
> @@ -1321,7 +1321,7 @@ F:	drivers/net/macb.*
>  ATMEL SPI DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:	Supported
> -F:	drivers/spi/atmel_spi.*
> +F:	drivers/spi/spi-atmel.c
>  
>  ATMEL USBA UDC DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
> @@ -5142,7 +5142,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  F:	arch/arm/mach-pxa/
>  F:	drivers/pcmcia/pxa2xx*
> -F:	drivers/spi/pxa2xx*
> +F:	drivers/spi/spi-pxa2xx*
>  F:	drivers/usb/gadget/pxa2*
>  F:	include/sound/pxa2xx-lib.h
>  F:	sound/arm/pxa*


-- 
Nicolas Ferre

