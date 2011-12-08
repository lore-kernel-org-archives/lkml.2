Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1LHA2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:28:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34409 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab1LHA2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:28:04 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-62-4ee00492f5c4
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
References: <20111207162256.GI22355@opensource.wolfsonmicro.com>
 <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 1/4] gpio: Explicitly index samsung_gpio_cfgs
Date: Thu, 08 Dec 2011 09:27:59 +0900
Message-id: <04c401ccb540$3d4813d0$b7d83b70$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy0/MldgwJU/7spTl6CMAlnkytZRwAQ19DQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> 
> Make it easier to follow the by number references into samsung_gpio_cfgs
> by putting the indexes into the code initialising the array, improving
> readability a bit. Ideally we wouldn't be using magic array indexes at all
> but this is easier than coming up with a better way.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

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

