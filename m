Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1FCSfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:35:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61406 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab1FCSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:35:44 -0400
Date: Fri, 3 Jun 2011 12:35:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] gpio: Samsung: make Kconfig options def_bool
Message-ID: <20110603183544.GI15616@ponder.secretlab.ca>
References: <201106021014.59699.hartleys@visionengravers.com>
 <20110603182545.GH15616@ponder.secretlab.ca>
 <ADE657CA350FB648AAC2C43247A983F001F381FC52E5@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F381FC52E5@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 01:32:41PM -0500, H Hartley Sweeten wrote:
> The Samsung GPIO drivers are always built-in when the relevant
> platform is selected.  Change the Kconfig symbol to def_bool y
> dependant on the platform.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Applied, thanks.

g.

> 
> ---
> 
> v2: updated based on mainline
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 4a7f631..2967002 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -87,32 +87,20 @@ config GPIO_IT8761E
>  	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
>  
>  config GPIO_EXYNOS4
> -	bool "Samsung Exynos4 GPIO library support"
> -	default y if CPU_EXYNOS4210
> -	depends on ARM
> -	help
> -	  Say yes here to support Samsung Exynos4 series SoCs GPIO library
> +	def_bool y
> +	depends on CPU_EXYNOS4210
>  
>  config GPIO_PLAT_SAMSUNG
> -	bool "Samsung SoCs GPIO library support"
> -	default y if SAMSUNG_GPIOLIB_4BIT
> -	depends on ARM
> -	help
> -	  Say yes here to support Samsung SoCs GPIO library
> +	def_bool y
> +	depends on SAMSUNG_GPIOLIB_4BIT
>  
>  config GPIO_S5PC100
> -	bool "Samsung S5PC100 GPIO library support"
> -	default y if CPU_S5PC100
> -	depends on ARM
> -	help
> -	  Say yes here to support Samsung S5PC100 SoCs GPIO library
> +	def_bool y
> +	depends on CPU_S5PC100
>  
>  config GPIO_S5PV210
> -	bool "Samsung S5PV210/S5PC110 GPIO library support"
> -	default y if CPU_S5PV210
> -	depends on ARM
> -	help
> -	  Say yes here to support Samsung S5PV210/S5PC110 SoCs GPIO library
> +	def_bool y
> +	depends on CPU_S5PV210
>  
>  config GPIO_PL061
>  	bool "PrimeCell PL061 GPIO support"
