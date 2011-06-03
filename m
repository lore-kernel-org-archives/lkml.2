Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1FCSZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:25:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44950 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1FCSZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:25:46 -0400
Date: Fri, 3 Jun 2011 12:25:45 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com
Subject: Re: [PATCH] gpio: Samsung: make Kconfig options def_bool
Message-ID: <20110603182545.GH15616@ponder.secretlab.ca>
References: <201106021014.59699.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201106021014.59699.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 10:14:58AM -0700, H Hartley Sweeten wrote:
> The Samsung GPIO drivers are always built-in when the relevant
> platform is selected.  Change the Kconfig symbol to def_bool y
> dependant on the platform.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Patch doesn't apply on mainline.  Linus already fixed up some stuff.

g.

> 
> ---
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 18c0b31..2e3cd11 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -87,32 +87,20 @@ config GPIO_IT8761E
>  	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
>  
>  config GPIO_EXYNOS4
> -	bool "Samsung Exynos4 GPIO library support"
> -	default y
> -	depends on ARM && CPU_EXYNOS4210
> -	help
> -	  Say yes here to support Samsung Exynos4 series SoCs GPIO library
> +	def_bool y
> +	depends on CPU_EXYNOS4210
>  
>  config GPIO_PLAT_SAMSUNG
> -	bool "Samsung SoCs GPIO library support"
> -	default y
> -	depends on ARM && SAMSUNG_GPIOLIB_4BIT
> -	help
> -	  Say yes here to support Samsung SoCs GPIO library
> +	def_bool y
> +	depends on SAMSUNG_GPIOLIB_4BIT
>  
>  config GPIO_S5PC100
> -	bool "Samsung S5PC100 GPIO library support"
> -	default y
> -	depends on ARM && CPU_S5PC100
> -	help
> -	  Say yes here to support Samsung S5PC100 SoCs GPIO library
> +	def_bool y
> +	depends on CPU_S5PC100
>  
>  config GPIO_S5PV210
> -	bool "Samsung S5PV210/S5PC110 GPIO library support"
> -	default y
> -	depends on ARM && CPU_S5PV210
> -	help
> -	  Say yes here to support Samsung S5PV210/S5PC110 SoCs GPIO library
> +	def_bool y
> +	depends on CPU_S5PV210
>  
>  config GPIO_PL061
>  	bool "PrimeCell PL061 GPIO support"
