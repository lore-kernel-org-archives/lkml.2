Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2KZJix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:38:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:35782 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2KZJiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:38:50 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a6-50b338a8c4db
From: Jingoo Han <jg1.han@samsung.com>
To: "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        linux-fbdev@vger.kernel.org, "'Paul Mundt'" <lethal@linux-sh.org>,
        "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Kuninori Morimoto'" <kuninori.morimoto.gx@renesas.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1353688515-30458-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1353688515-30458-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-reply-to: <1353688515-30458-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH 2/5] backlight: Add Sanyo LV5207LP backlight driver
Date: Mon, 26 Nov 2012 18:38:47 +0900
Message-id: <004d01cdcbb9$d5cfb500$816f1f00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3JmGT7pxKTHUH6QaSBeZ9Vj6fL3wCIJLHg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ90VFpsDDJ49lrE40feB1eLyrjls
	FnP+TGF2YPb4vEkugDGKyyYlNSezLLVI3y6BK6Pz1gPGgov2FRNOzmdrYNxh3MXIySEhYCJx
	a+VPNghbTOLCvfVANheHkMAyRonPMxvZYYp2f2lhBbGFBKYzSny9zwFR9ItRorXtPCNIgk1A
	TeLLl8NgDSICThJbtn4Cs5kFnjBJ/LllB9GwmlHizcLpYAlOgRiJ3nU3mUBsYQF3iXmH1oBt
	YBFQlZh05S9zFyMHB6+ArcT+bmeQMK+AoMSPyfdYIGZqSazfeZwJwpaX2LzmLVi5hIC6xKO/
	uhAnGEn0T5jIClEiIrHvxTtGiOkCEt8mH2KBKJeV2HSAGeQyCYFN7BKr/t6CBoSkxMEVN1gm
	MErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYIdEmvYNxVYPF
	IUYBDkYlHl7JY5sChFgTy4orcw8xSnAwK4nwTmQCCvGmJFZWpRblxxeV5qQWH2L0Abp8IrOU
	aHI+MBHklcQbGhubmJmYmphbmpqb4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cBodfzz
	xGSJ+eadojVJh5gidY4vTvyy6euVhE8bRArXal2UZRYVdHCdsOX+WsvlZwKn++kr3rtzatnm
	4L+u0xc3WR6wuRC+dFVsrtCkzJelal15X3/Xmp3tZp1iZbAuuHjNvXbl+aVpnJe65isvt7z4
	t9d0/aLf8y8cO7ymU3zXVd4Tbx8l39saqsRSnJFoqMVcVJwIAGkIbjXjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jQd0VFpsDDG7fE7c40feB1eLyrjls
	FnP+TGF2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjGj89YD
	xoKL9hUTTs5na2DcYdzFyMkhIWAisftLCyuELSZx4d56NhBbSGA6o8TX+xxdjFxA9i9Gida2
	84wgCTYBNYkvXw6zg9giAk4SW7Z+ArOZBZ4wSfy5ZQfRsJpR4s3C6WAJToEYid51N5lAbGEB
	d4l5h9aAbWMRUJWYdOUvcxcjBwevgK3E/m5nkDCvgKDEj8n3WCBmakms33mcCcKWl9i85i1Y
	uYSAusSjv7oQJxhJ9E+YyApRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4lp9J72Bc1WBxiFGAg1GJh1fy2KYAIdbEsuLK3EOMEhzMSiK8
	E5mAQrwpiZVVqUX58UWlOanFhxh9gP6cyCwlmpwPTDN5JfGGxiZmRpZGZhZGJubmOISVxHmb
	PVIChATSE0tSs1NTC1KLYMYxcXBKNTAazbCbfjTOIrsr8lDqrHfiEgdPBjTkLJo7R34J/4UT
	2o0Of6a/anK60nz1plzzpPi9Sndt3gh/f8/Vuv1G8w41M18/jV+KgQ8XX/GcPVnXvO5L6U4P
	hb2Hm4w2f1ILfxCQ5nInuLPJ8OWlq7PKTJfwfSkPsszTmhUf6Fjje/kQr3O9jster9tKLMUZ
	iYZazEXFiQB4PuCJEgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 24, 2012 1:35 AM, Laurent Pinchart wrote
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>


CC'ed Andrew Morton


Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/Kconfig        |    6 +
>  drivers/video/backlight/Makefile       |    1 +
>  drivers/video/backlight/lv5207lp.c     |  171 ++++++++++++++++++++++++++++++++
>  include/linux/platform_data/lv5207lp.h |   20 ++++
>  4 files changed, 198 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/backlight/lv5207lp.c
>  create mode 100644 include/linux/platform_data/lv5207lp.h
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 259442d..92ce5aa 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -397,6 +397,12 @@ config BACKLIGHT_GPIO
>  	  If you have a LCD backlight adjustable by GPIO, say Y to enable
>  	  this driver.
> 
> +config BACKLIGHT_LV5207LP
> +	tristate "Sanyo LV5207LP Backlight"
> +	depends on I2C
> +	help
> +	  If you have a Sanyo LV5207LP say Y to enable the backlight driver.
> +
>  endif # BACKLIGHT_CLASS_DEVICE
> 
>  endif # BACKLIGHT_LCD_SUPPORT
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index ec91c4a..125b8ad 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -46,3 +46,4 @@ obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
>  obj-$(CONFIG_BACKLIGHT_OT200) += ot200_bl.o
>  obj-$(CONFIG_BACKLIGHT_TPS65217) += tps65217_bl.o
>  obj-$(CONFIG_BACKLIGHT_GPIO)	+= gpio_backlight.o
> +obj-$(CONFIG_BACKLIGHT_LV5207LP)	+= lv5207lp.o
> diff --git a/drivers/video/backlight/lv5207lp.c b/drivers/video/backlight/lv5207lp.c
> new file mode 100644
> index 0000000..b06f35c
> --- /dev/null
> +++ b/drivers/video/backlight/lv5207lp.c
> @@ -0,0 +1,171 @@
> +/*
> + * Sanyo LV5207LP LED Driver
> + *
> + * Copyright (C) 2012 Ideas on board SPRL
> + *
> + * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/backlight.h>
> +#include <linux/err.h>
> +#include <linux/fb.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/platform_data/lv5207lp.h>
> +
> +#define LV5207LP_CTRL1			0x00
> +#define LV5207LP_CPSW			(1 << 7)
> +#define LV5207LP_SCTEN			(1 << 6)
> +#define LV5207LP_C10			(1 << 5)
> +#define LV5207LP_CKSW			(1 << 4)
> +#define LV5207LP_RSW			(1 << 3)
> +#define LV5207LP_GSW			(1 << 2)
> +#define LV5207LP_BSW			(1 << 1)
> +#define LV5207LP_CTRL2			0x01
> +#define LV5207LP_MSW			(1 << 7)
> +#define LV5207LP_MLED4			(1 << 6)
> +#define LV5207LP_RED			0x02
> +#define LV5207LP_GREEN			0x03
> +#define LV5207LP_BLUE			0x04
> +
> +#define LV5207LP_MAX_BRIGHTNESS		32
> +
> +struct lv5207lp {
> +	struct i2c_client *client;
> +	struct backlight_device *backlight;
> +	struct lv5207lp_platform_data *pdata;
> +};
> +
> +static int lv5207lp_write(struct lv5207lp *lv, u8 reg, u8 data)
> +{
> +	return i2c_smbus_write_byte_data(lv->client, reg, data);
> +}
> +
> +static int lv5207lp_backlight_update_status(struct backlight_device *backlight)
> +{
> +	struct lv5207lp *lv = bl_get_data(backlight);
> +	int brightness = backlight->props.brightness;
> +
> +	if (backlight->props.power != FB_BLANK_UNBLANK ||
> +	    backlight->props.fb_blank != FB_BLANK_UNBLANK ||
> +	    backlight->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
> +		brightness = 0;
> +
> +	if (brightness) {
> +		lv5207lp_write(lv, LV5207LP_CTRL1,
> +			       LV5207LP_CPSW | LV5207LP_C10 | LV5207LP_CKSW);
> +		lv5207lp_write(lv, LV5207LP_CTRL2,
> +			       LV5207LP_MSW | LV5207LP_MLED4 |
> +			       (brightness - 1));
> +	} else {
> +		lv5207lp_write(lv, LV5207LP_CTRL1, 0);
> +		lv5207lp_write(lv, LV5207LP_CTRL2, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static int lv5207lp_backlight_get_brightness(struct backlight_device *backlight)
> +{
> +	return backlight->props.brightness;
> +}
> +
> +static int lv5207lp_backlight_check_fb(struct backlight_device *backlight,
> +				       struct fb_info *info)
> +{
> +	struct lv5207lp *lv = bl_get_data(backlight);
> +
> +	return lv->pdata->fbdev == info->dev;
> +}
> +
> +static const struct backlight_ops lv5207lp_backlight_ops = {
> +	.options	= BL_CORE_SUSPENDRESUME,
> +	.update_status	= lv5207lp_backlight_update_status,
> +	.get_brightness	= lv5207lp_backlight_get_brightness,
> +	.check_fb	= lv5207lp_backlight_check_fb,
> +};
> +
> +static int lv5207lp_probe(struct i2c_client *client,
> +			  const struct i2c_device_id *id)
> +{
> +	struct lv5207lp_platform_data *pdata = client->dev.platform_data;
> +	struct backlight_device *backlight;
> +	struct backlight_properties props;
> +	struct lv5207lp *lv;
> +
> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "No platform data supplied\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		dev_warn(&client->dev,
> +			 "I2C adapter doesn't support I2C_FUNC_SMBUS_BYTE\n");
> +		return -EIO;
> +	}
> +
> +	lv = devm_kzalloc(&client->dev, sizeof(*lv), GFP_KERNEL);
> +	if (!lv)
> +		return -ENOMEM;
> +
> +	lv->client = client;
> +	lv->pdata = pdata;
> +
> +	memset(&props, 0, sizeof(props));
> +	props.type = BACKLIGHT_RAW;
> +	props.max_brightness = min_t(unsigned int, pdata->max_value,
> +				     LV5207LP_MAX_BRIGHTNESS);
> +	props.brightness = clamp_t(unsigned int, pdata->def_value, 0,
> +				   props.max_brightness);
> +
> +	backlight = backlight_device_register(dev_name(&client->dev),
> +					      &lv->client->dev, lv,
> +					      &lv5207lp_backlight_ops, &props);
> +	if (IS_ERR(backlight)) {
> +		dev_err(&client->dev, "failed to register backlight\n");
> +		return PTR_ERR(backlight);
> +	}
> +
> +	backlight_update_status(backlight);
> +	i2c_set_clientdata(client, backlight);
> +
> +	return 0;
> +}
> +
> +static int lv5207lp_remove(struct i2c_client *client)
> +{
> +	struct backlight_device *backlight = i2c_get_clientdata(client);
> +
> +	backlight->props.brightness = 0;
> +	backlight_update_status(backlight);
> +	backlight_device_unregister(backlight);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id lv5207lp_ids[] = {
> +	{ "lv5207lp", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, lv5207lp_ids);
> +
> +static struct i2c_driver lv5207lp_driver = {
> +	.driver = {
> +		.name = "lv5207lp",
> +	},
> +	.probe = lv5207lp_probe,
> +	.remove = lv5207lp_remove,
> +	.id_table = lv5207lp_ids,
> +};
> +
> +module_i2c_driver(lv5207lp_driver);
> +
> +MODULE_DESCRIPTION("Sanyo LV5207LP Backlight Driver");
> +MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/platform_data/lv5207lp.h b/include/linux/platform_data/lv5207lp.h
> new file mode 100644
> index 0000000..ac95cb1
> --- /dev/null
> +++ b/include/linux/platform_data/lv5207lp.h
> @@ -0,0 +1,20 @@
> +/*
> + * lv5207lp.h - Sanyo LV5207LP LEDs Driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __LV5207LP_H__
> +#define __LV5207LP_H__
> +
> +struct device;
> +
> +struct lv5207lp_platform_data {
> +	struct device *fbdev;
> +	unsigned int max_value;
> +	unsigned int def_value;
> +};
> +
> +#endif
> +
> --
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

