Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1KUNg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:36:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56782 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1KUNg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:36:26 -0500
Date: Mon, 21 Nov 2011 13:36:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>, Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: drop 'ARCH_MX31' and 'ARCH_MX35'
Message-ID: <20111121133603.GR9581@n2100.arm.linux.org.uk>
References: <1321882445.32195.3.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321882445.32195.3.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 02:34:05PM +0100, Paul Bolle wrote:
> Commit 27ad4bf72a ("ARM: imx: move mx3 support to mach-imx") kept
> ARCH_MX31 and ARCH_MX35 'for compatibility'. Now that they aren't
> actually used anymore, they can be dropped entirely.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Sascha should be handing this patch.

ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
M:      Sascha Hauer <kernel@pengutronix.de>
L:      linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
S:      Maintained
T:      git git://git.pengutronix.de/git/imx/linux-2.6.git
F:      arch/arm/mach-mx*/
F:      arch/arm/plat-mxc/

It may be an idea if MAINTAINERS gets updated too, so these patches find
their way to the right person...

> ---
> "git grep" tested only.
> 
>  arch/arm/mach-imx/Kconfig |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 5f7f9c2..c44aa97 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -10,11 +10,6 @@ config HAVE_IMX_MMDC
>  config HAVE_IMX_SRC
>  	bool
>  
> -#
> -# ARCH_MX31 and ARCH_MX35 are left for compatibility
> -# Some usages assume that having one of them implies not having (e.g.) ARCH_MX2.
> -# To easily distinguish good and reviewed from unreviewed usages new (and IMHO
> -# more sensible) names are used: SOC_IMX31 and SOC_IMX35
>  config ARCH_MX1
>  	bool
>  
> @@ -27,12 +22,6 @@ config ARCH_MX25
>  config MACH_MX27
>  	bool
>  
> -config ARCH_MX31
> -	bool
> -
> -config ARCH_MX35
> -	bool
> -
>  config SOC_IMX1
>  	bool
>  	select ARCH_MX1
> @@ -72,7 +61,6 @@ config SOC_IMX31
>  	select CPU_V6
>  	select IMX_HAVE_PLATFORM_MXC_RNGA
>  	select ARCH_MXC_AUDMUX_V2
> -	select ARCH_MX31
>  	select MXC_AVIC
>  	select SMP_ON_UP if SMP
>  
> @@ -82,7 +70,6 @@ config SOC_IMX35
>  	select ARCH_MXC_IOMUX_V3
>  	select ARCH_MXC_AUDMUX_V2
>  	select HAVE_EPIT
> -	select ARCH_MX35
>  	select MXC_AVIC
>  	select SMP_ON_UP if SMP
>  
> -- 
> 1.7.7.3
> 
