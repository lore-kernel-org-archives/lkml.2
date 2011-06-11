Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab1FKF2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 01:28:17 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:51976 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1FKF2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 01:28:16 -0400
Date: Fri, 10 Jun 2011 23:28:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH] gpio/ep93xx: Add missing EP93XX_GPIO_PHYS_BASE define
Message-ID: <20110611052814.GA16924@ponder.secretlab.ca>
References: <201106100908.18678.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106100908.18678.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 09:08:17AM -0700, H Hartley Sweeten wrote:
> The patch to convert of the ep93xx gpio driver to a platform_driver is
> missing the define for the memory resource that is passed to the driver.
> 
> This is needed to prevent a build error.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Ryan Mallon <ryan@bluewatersys.com>

Applied, thanks.

g.

> 
> ---
> 
> Grant, can you pick this up in your tree to prevent the build error?
> 
> diff --git a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
> index 9ac4d10..c4a7b84 100644
> --- a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
> +++ b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
> @@ -98,6 +98,7 @@
>  
>  #define EP93XX_SECURITY_BASE		EP93XX_APB_IOMEM(0x00030000)
>  
> +#define EP93XX_GPIO_PHYS_BASE		EP93XX_APB_PHYS(0x00040000)
>  #define EP93XX_GPIO_BASE		EP93XX_APB_IOMEM(0x00040000)
>  #define EP93XX_GPIO_REG(x)		(EP93XX_GPIO_BASE + (x))
>  #define EP93XX_GPIO_F_INT_STATUS	EP93XX_GPIO_REG(0x5c)
