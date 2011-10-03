Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1JCSSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:18:37 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18182 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab1JCSSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:18:30 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19pdpf1mU7DbC+5sEt5Kdku
Date: Mon, 3 Oct 2011 11:18:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/30] ARM: omap2: select twl4030 support on boards
 that need it
Message-ID: <20111003181826.GZ6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-24-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317566760-25681-24-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [111002 07:13]:
> These three boards unconditionally use the twl4030 driver
> from the board-zoom-display.c file. Make sure that the driver
> is always there.
> We also need to select the I2C core so we are able to build
> that driver.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/Kconfig |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 57b66d5..4deeade 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -253,6 +253,8 @@ config MACH_OMAP_ZOOM2
>  	select SERIAL_CORE_CONSOLE
>  	select SERIAL_8250_CONSOLE
>  	select REGULATOR_FIXED_VOLTAGE
> +	select TWL4030_CORE
> +	select I2C
>  
>  config MACH_OMAP_ZOOM3
>  	bool "OMAP3630 Zoom3 board"
> @@ -263,6 +265,8 @@ config MACH_OMAP_ZOOM3
>  	select SERIAL_CORE_CONSOLE
>  	select SERIAL_8250_CONSOLE
>  	select REGULATOR_FIXED_VOLTAGE
> +	select TWL4030_CORE
> +	select I2C
>  
>  config MACH_CM_T35
>  	bool "CompuLab CM-T35/CM-T3730 modules"
> @@ -304,6 +308,8 @@ config MACH_OMAP_3630SDP
>  	depends on ARCH_OMAP3
>  	default y
>  	select OMAP_PACKAGE_CBP
> +	select TWL4030_CORE
> +	select I2C
>  
>  config MACH_TI8168EVM
>  	bool "TI8168 Evaluation Module"
> -- 
> 1.7.5.4
> 
