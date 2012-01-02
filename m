Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2ABH1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 02:27:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2ABH1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 02:27:23 -0500
Date: Mon, 2 Jan 2012 00:27:19 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] gpio: Explicitly index samsung_gpio_cfgs
Message-ID: <20120102072719.GC13015@ponder.secretlab.ca>
References: <20111207162256.GI22355@opensource.wolfsonmicro.com>
 <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 12:23:58AM +0800, Mark Brown wrote:
> Make it easier to follow the by number references into samsung_gpio_cfgs
> by putting the indexes into the code initialising the array, improving
> readability a bit. Ideally we wouldn't be using magic array indexes at all
> but this is easier than coming up with a better way.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-samsung.c |   29 +++++++++++++++++++----------
>  1 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index 6b4d23f..f1c1ecd 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -470,33 +470,42 @@ static struct samsung_gpio_cfg s5p64x0_gpio_cfg_rbank = {
>  #endif
>  
>  static struct samsung_gpio_cfg samsung_gpio_cfgs[] = {
> -	{
> +	[0] = {
>  		.cfg_eint	= 0x0,
> -	}, {
> +	},
> +	[1] = {
>  		.cfg_eint	= 0x3,
> -	}, {
> +	},
> +	[2] = {
>  		.cfg_eint	= 0x7,
> -	}, {
> +	},
> +	[3] = {
>  		.cfg_eint	= 0xF,
> -	}, {
> +	},
> +	[4] = {
>  		.cfg_eint	= 0x0,
>  		.set_config	= samsung_gpio_setcfg_2bit,
>  		.get_config	= samsung_gpio_getcfg_2bit,
> -	}, {
> +	},
> +	[5] = {
>  		.cfg_eint	= 0x2,
>  		.set_config	= samsung_gpio_setcfg_2bit,
>  		.get_config	= samsung_gpio_getcfg_2bit,
> -	}, {
> +	},
> +	[6] = {
>  		.cfg_eint	= 0x3,
>  		.set_config	= samsung_gpio_setcfg_2bit,
>  		.get_config	= samsung_gpio_getcfg_2bit,
> -	}, {
> +	},
> +	[7] = {
>  		.set_config	= samsung_gpio_setcfg_2bit,
>  		.get_config	= samsung_gpio_getcfg_2bit,
> -	}, {
> +	},
> +	[8] = {
>  		.set_pull	= exynos4_gpio_setpull,
>  		.get_pull	= exynos4_gpio_getpull,
> -	}, {
> +	},
> +	[9] = {
>  		.cfg_eint	= 0x3,
>  		.set_pull	= exynos4_gpio_setpull,
>  		.get_pull	= exynos4_gpio_getpull,
> -- 
> 1.7.7.3
> 
