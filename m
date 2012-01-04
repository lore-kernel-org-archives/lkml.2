Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2ADTGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:06:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43766 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2ADTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:06:10 -0500
Date: Wed, 4 Jan 2012 10:53:51 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] MAINTAINERS: spi: Update F: patterns
Message-ID: <20120104175351.GE15503@ponder.secretlab.ca>
References: <cover.1323418149.git.joe@perches.com>
 <86f4a9099c8ff7961190a540155356446dda2ade.1323418149.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86f4a9099c8ff7961190a540155356446dda2ade.1323418149.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 12:12:54AM -0800, Joe Perches wrote:
> commit ca632f55669 ("spi: reorganize drivers")
> renamed the files, update the F: patterns.
> 
> CC: Grant Likely <grant.likely@secretlab.ca>
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 410f190..68d5147 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1151,7 +1151,7 @@ F:	drivers/watchdog/nuc900_wdt.c
>  F:	drivers/net/ethernet/nuvoton/w90p910_ether.c
>  F:	drivers/mtd/nand/nuc900_nand.c
>  F:	drivers/rtc/rtc-nuc900.c
> -F:	drivers/spi/spi_nuc900.c
> +F:	drivers/spi/spi-nuc900.c
>  F:	drivers/usb/host/ehci-w90x900.c
>  F:	drivers/video/nuc900fb.c
>  
> @@ -1355,7 +1355,7 @@ F:	drivers/net/ethernet/cadence/
>  ATMEL SPI DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:	Supported
> -F:	drivers/spi/atmel_spi.*
> +F:	drivers/spi/spi-atmel.*
>  
>  ATMEL USBA UDC DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
> @@ -5280,7 +5280,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  F:	arch/arm/mach-pxa/
>  F:	drivers/pcmcia/pxa2xx*
> -F:	drivers/spi/pxa2xx*
> +F:	drivers/spi/spi-pxa2xx*
>  F:	drivers/usb/gadget/pxa2*
>  F:	include/sound/pxa2xx-lib.h
>  F:	sound/arm/pxa*
> -- 
> 1.7.8.111.gad25c.dirty
> 
