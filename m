Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab2KZJtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:49:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37228 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2KZJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:49:39 -0500
X-AuditID: cbfee610-b7fd06d000005bdb-18-50b33b31ab0e
Date: Mon, 26 Nov 2012 09:49:37 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 1/5] backlight: Add GPIO-based backlight driver
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20121126094831916@jg1.han
Msgkey: 20121126094831916@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121126094831916@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <32552643.33371353923376540.JavaMail.weblogic@epv6ml07>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsVy+t8zA11D680BBgee6Vhc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXM+PxyGWvBq4CKJR//MzUw3vHrYuTkEBJQkph0ci8jiC0hYCLRuXEN
	C4QtJnHh3nq2LkYuoJpljBL37q1hgyk6NnsjG0TzfEaJYzvBBrEIqEp8WHkXLM4moC4x4Xcz
	2CBhAWeJqXe/sYPYIgJOEreblzGB2MwCp5klGr+pQ8yRlbg3eTYziM0rIChxcuYToF4OoF0K
	ErO2VoKYvAKKEmfmOUJcICFx5/5+VgibV2JG+1Ook+Ukpn1dwwxhS0ucn7WBEeaVxd8fQ8X5
	JY7d3sEEMZ1X4sn9YJgxuzd/gXpQQGLqmYNQraoS5w8uhxrPJ7Fm4VsoW1Di9LVuZpjeho2/
	2SGeUpSY0v0QytaS+PJjHxuqp0BsZ4kXe+czTWBUnoUkNQtJ+ywk7chqFjCyrGIUTS1ILihO
	Sk81Q47qTYyQFCiwg3FJg8UhRgEORiUeXsljmwKEWBPLiitzDzFKcDArifBOZAIK8aYkVlal
	FuXHF5XmpBYfYpzICIy/icxSosn5wASdVxJvaGxsYmZiamJuaWpuSoywuZGpATD5GhiSKKwk
	zsteMT1ASCA9sSQ1OzW1ILUI5igmDk6pBsa+H949716LyF5Je3nh+ILiuxmGXxpv9C/MX8r/
	0Cx3aZRMuLX/Gm6vxRsn7DC53FDXyfyt+qfN4XkbXzd4ilzhWpotkiUU0cGaHL/TUfrts788
	ge+DzrBX8biocofXzxFjVhI0eya108RTUu/zqxTxwq+26jkzMzVVWxVP/u84t4JpwQWerUos
	xRmJhlrMRcWJAJE4Lj70AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t/tmbqG1psDDBat0bC4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnrGlrFWhgYGRqZAVQkZ
	GZ9fLmMteBVQseTjf6YGxjt+XYycHEICShKTTu5lBLElBEwkjs3eyAZhi0lcuLeeDaJmPqPE
	sZ1g9SwCqhIfVt4Fi7MJqEtM+N3MAmILCzhLTL37jR3EFhFwkrjdvIwJxGYWOM0s0fhNHWKO
	rMS9ybOZQWxeAUGJkzOfAPVyAO1SkJi1tRLE5BVQlDgzzxHiAgmJO/f3s0LYvBIz2p+yQNhy
	EtO+rmGGsKUlzs/awAhz8eLvj6Hi/BLHbu9ggpjOK/HkfjDMmN2bv0A9KCAx9cxBqFZVifMH
	l0ON55NYs/AtlC0ocfpaNzNMb8PG3+wQTylKTOl+CGVrSXz5sY8N1VMgtrPEi73zmSYwys1C
	kpqFpH0WknZkNQsYWVYxiqYWJBcUJ6WnmukVJ+YWl+al6yXn525iBCenZwI7GJc0WBxiFOBg
	VOLhlTy2KUCINbGsuDL3EKMEB7OSCO9EJqAQb0piZVVqUX58UWlOavEhRh9g9E1klhJNzgcm
	zrySeENjYxMzE1NzAwsDS3McwkrivOwV0wOEBNITS1KzU1MLUotgxjFxcEo1MEotTLTMm/fP
	rayk8tmmnT8buSNd+5sj34ZGX/+8e6lwzK8p+3/0tX3tfH7gwISqGYEdoT4RS3+8eON+sjbY
	wTtN3fvBm9+bRNmYfyq+P3l883Pz5dYaPzw3/mFaL7/ZPC/04+obXROvFNUvnMPJwmYx94eP
	BF/+s7reS5Pfecm1xPnLldw4LavEUpyRaKjFXFScCABNvb+rewMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAQ9njo6023228

On Saturday, November 24, 2012 1:35 AM, Laurent Pinchart wrote
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

CC'ed Andrew Morton

It looks good. Also, I tested this patch with SMDK4210 board.
Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/Kconfig          |    7 ++
>  drivers/video/backlight/Makefile         |    1 +
>  drivers/video/backlight/gpio_backlight.c |  158 ++++++++++++++++++++++++++++++
>  include/video/gpio_backlight.h           |   21 ++++
>  4 files changed, 187 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/backlight/gpio_backlight.c
>  create mode 100644 include/video/gpio_backlight.h
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 765a945..259442d 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -390,6 +390,13 @@ config BACKLIGHT_TPS65217
>  	  If you have a Texas Instruments TPS65217 say Y to enable the
>  	  backlight driver.
> 
> +config BACKLIGHT_GPIO
> +	tristate "Generic GPIO based Backlight Driver"
> +	depends on GENERIC_GPIO
> +	help
> +	  If you have a LCD backlight adjustable by GPIO, say Y to enable
> +	  this driver.
> +
>  endif # BACKLIGHT_CLASS_DEVICE
> 
>  endif # BACKLIGHT_LCD_SUPPORT
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index e7ce729..ec91c4a 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -45,3 +45,4 @@ obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
>  obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
>  obj-$(CONFIG_BACKLIGHT_OT200) += ot200_bl.o
>  obj-$(CONFIG_BACKLIGHT_TPS65217) += tps65217_bl.o
> +obj-$(CONFIG_BACKLIGHT_GPIO)	+= gpio_backlight.o
> diff --git a/drivers/video/backlight/gpio_backlight.c b/drivers/video/backlight/gpio_backlight.c
> new file mode 100644
> index 0000000..5a8cd34
> --- /dev/null
> +++ b/drivers/video/backlight/gpio_backlight.c
> @@ -0,0 +1,158 @@
> +/*
> + * gpio_backlight.c - Simple GPIO-controlled backlight
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/backlight.h>
> +#include <linux/err.h>
> +#include <linux/fb.h>
> +#include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <video/gpio_backlight.h>
> +
> +struct gpio_backlight {
> +	struct device *dev;
> +	struct device *fbdev;
> +
> +	int gpio;
> +	int active;
> +};
> +
> +static int gpio_backlight_update_status(struct backlight_device *bl)
> +{
> +	struct gpio_backlight *gbl = bl_get_data(bl);
> +	int brightness = bl->props.brightness;
> +
> +	if (bl->props.power != FB_BLANK_UNBLANK ||
> +	    bl->props.fb_blank != FB_BLANK_UNBLANK ||
> +	    bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
> +		brightness = 0;
> +
> +	gpio_set_value(gbl->gpio, brightness ? gbl->active : !gbl->active);
> +
> +	return 0;
> +}
> +
> +static int gpio_backlight_get_brightness(struct backlight_device *bl)
> +{
> +	return bl->props.brightness;
> +}
> +
> +static int gpio_backlight_check_fb(struct backlight_device *bl,
> +				   struct fb_info *info)
> +{
> +	struct gpio_backlight *gbl = bl_get_data(bl);
> +
> +	return gbl->fbdev == info->dev;
> +}
> +
> +static const struct backlight_ops gpio_backlight_ops = {
> +	.update_status	= gpio_backlight_update_status,
> +	.get_brightness	= gpio_backlight_get_brightness,
> +	.check_fb	= gpio_backlight_check_fb,
> +};
> +
> +#ifdef CONFIG_PM
> +static int gpio_backlight_suspend(struct device *dev)
> +{
> +	struct backlight_device *bl = dev_get_drvdata(dev);
> +	struct gpio_backlight *gbl = bl_get_data(bl);
> +
> +	gpio_set_value(gbl->gpio, !gbl->active);
> +
> +	return 0;
> +}
> +
> +static int gpio_backlight_resume(struct device *dev)
> +{
> +	struct backlight_device *bl = dev_get_drvdata(dev);
> +
> +	backlight_update_status(bl);
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(gpio_backlight_pm_ops, gpio_backlight_suspend,
> +			 gpio_backlight_resume);
> +
> +#endif
> +
> +static int __devinit gpio_backlight_probe(struct platform_device *pdev)
> +{
> +	struct gpio_backlight_platform_data *pdata = pdev->dev.platform_data;
> +	struct backlight_properties props;
> +	struct backlight_device *bl;
> +	struct gpio_backlight *gbl;
> +	int ret;
> +
> +	gbl = devm_kzalloc(&pdev->dev, sizeof(*gbl), GFP_KERNEL);
> +	if (gbl == NULL)
> +		return -ENOMEM;
> +
> +	gbl->dev = &pdev->dev;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "failed to find platform data\n");
> +		return -ENODEV;
> +	}
> +
> +	gbl->fbdev = pdata->fbdev;
> +	gbl->gpio = pdata->gpio;
> +	gbl->active = pdata->active_low ? 0 : 1;
> +
> +	ret = devm_gpio_request_one(gbl->dev, gbl->gpio, GPIOF_DIR_OUT,
> +				    pdata->name);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "unable to request GPIO\n");
> +		return ret;
> +	}
> +
> +	memset(&props, 0, sizeof(props));
> +	props.type = BACKLIGHT_RAW;
> +	props.max_brightness = 1;
> +	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, gbl,
> +				       &gpio_backlight_ops, &props);
> +	if (IS_ERR(bl)) {
> +		dev_err(&pdev->dev, "failed to register backlight\n");
> +		return PTR_ERR(bl);
> +	}
> +
> +	bl->props.brightness = pdata->def_value;
> +	backlight_update_status(bl);
> +
> +	platform_set_drvdata(pdev, bl);
> +	return 0;
> +}
> +
> +static int __devexit gpio_backlight_remove(struct platform_device *pdev)
> +{
> +	struct backlight_device *bl = platform_get_drvdata(pdev);
> +
> +	backlight_device_unregister(bl);
> +	return 0;
> +}
> +
> +static struct platform_driver gpio_backlight_driver = {
> +	.driver		= {
> +		.name		= "gpio-backlight",
> +		.owner		= THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm		= &gpio_backlight_pm_ops,
> +#endif
> +	},
> +	.probe		= gpio_backlight_probe,
> +	.remove		= __devexit_p(gpio_backlight_remove),
> +};
> +
> +module_platform_driver(gpio_backlight_driver);
> +
> +MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
> +MODULE_DESCRIPTION("GPIO-based Backlight Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:gpio-backlight");
> diff --git a/include/video/gpio_backlight.h b/include/video/gpio_backlight.h
> new file mode 100644
> index 0000000..5ae0d9c
> --- /dev/null
> +++ b/include/video/gpio_backlight.h
> @@ -0,0 +1,21 @@
> +/*
> + * gpio_backlight.h - Simple GPIO-controlled backlight
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __GPIO_BACKLIGHT_H__
> +#define __GPIO_BACKLIGHT_H__
> +
> +struct device;
> +
> +struct gpio_backlight_platform_data {
> +	struct device *fbdev;
> +	int gpio;
> +	int def_value;
> +	bool active_low;
> +	const char *name;
> +};
> +
> +#endif
> --
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
