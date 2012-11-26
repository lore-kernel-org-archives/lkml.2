Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2KZJsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:48:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37189 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2KZJsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:48:08 -0500
X-AuditID: cbfee60b-b7f356d0000018d6-9e-50b33ad62621
Date: Mon, 26 Nov 2012 09:48:06 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 2/5] backlight: Add Sanyo LV5207LP backlight driver
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20121126094612182@jg1.han
Msgkey: 20121126094612182@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121126094612182@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <12056392.33321353923285279.JavaMail.weblogic@epv6ml07>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zfd1rVpsDDP4fVLS4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqYcbEhqKAtvKJxwQK2BsYnIV2MnBxCAkoSk07uZQSxJQRMJDbtvMQC
	YYtJXLi3nq2LkQuoZhmjxKwda4EcDrCir09ZIOLzGSV+7VoH1swioCqx7tZUdhCbTUBdYsLv
	ZrBBwgLuEvMOrWEFsUUEnCRuNy9jAmlmFpjGLPHu7m02iCtkJe5Nns0MYvMKCEqcnPkE6goF
	ibPPTjBBxBUllk+dwQYRl5C4c38/K4TNKzGj/SlUvZzEtK9rmCFsaYnzszYwwnyz+PtjqDi/
	xLHbO5ggnuGVeHI/GGbM7s1foMYLSEw9cxCqVVVix4PD7BA2n8SahW+hVglKnL7WzQzT27Dx
	N1gNM9CZU7ofQtlaEl9+7GND9RYHkO0ssWaZ7wRG5VlIMrOQdM9C0o2sZgEjyypG0dSC5ILi
	pPRUQ+S43sQISYLcOxhnNVgcYhTgYFTi4ZU8tilAiDWxrLgy9xCjBAezkgjvRCagEG9KYmVV
	alF+fFFpTmrxIcaJjMAYnMgsJZqcD0zReSXxhsbGJmYmpibmlqbmpsQImxuZGgDTr4EhicJK
	4rwKFdMDhATSE0tSs1NTC1KLYI5i4uCUamB0ClV690Ps06JTYjxB/yrMFHSPzf+2ceZfhm81
	tUke79MKuLnE12bGrO2ymmNdUCdp8XqG2NNdCj+ONNyLcG1nPHwuJ7KlW27PSl2FxQ+jVVX8
	Jr2Ns+DeOWHdESmenN2RxcL74oO5wtnqF309f5PHwGGvP6PgtIjs2M1Ra05Ms0zpmCbrHaDE
	UpyRaKjFXFScCADnQ5gW9QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t/tmbrXrDYHGJzqk7G4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnrGlrFWhgYGRqZAVQkZ
	GRcbggrawisaFyxga2B8EtLFyMkhJKAkMenkXsYuRg4OCQETia9PWUDCEgJiEhfurWfrYuQC
	KpnPKPFr1zpGkASLgKrEultT2UFsNgF1iQm/m8EahAXcJeYdWsMKYosIOEncbl7GBNLMLDCN
	WeLd3dtsEMtkJe5Nns0MYvMKCEqcnPkEapuCxNlnJ5gg4ooSy6fOYIOIS0jcub+fFcLmlZjR
	DnOdnMS0r2uYIWxpifOzNjDCXL34+2OoOL/Esds7mCAe45V4cj8YZszuzV+gxgtITD1zEKpV
	VWLHg8PsEDafxJqFb6FWCUqcvtbNDNPbsPE3WA0z0JlTuh9C2VoSX37sY0P1FgeQ7SyxZpnv
	BEa5WUgys5B0z0LSjaxmASPLKkbR1ILkguKk9FRDveLE3OLSvHS95PzcTYzg9PSMewfjrAaL
	Q4wCHIxKPLySxzYFCLEmlhVX5h5ilOBgVhLhncgEFOJNSaysSi3Kjy8qzUktPsToA4zAicxS
	osn5wNSZVxJvaGxsYmZiam5gYWBpjkNYSZxXoWJ6gJBAemJJanZqakFqEcw4Jg5OqQbG0M88
	0ls8PGr51x967St7+aPaN2bdrlkt+24mHsg6Y/Mmf2/YzgWzNxwNbhYyP/plT1GChnBW+9OT
	201Vq34aL2mcW1N8XbfnbI/MtDfZ6yWzd2R+UvA8aREX0PhPZvPifr1rgsutXhTyyBvell/9
	4YmK8kUG1xl74xbMVuZfuEB3h4biX1kfJZbijERDLeai4kQASCIKDnwDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAQ9mFep023221

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
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
