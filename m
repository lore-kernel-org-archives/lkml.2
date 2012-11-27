Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab2K0BKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:10:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48494 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab2K0BKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:10:39 -0500
X-AuditID: cbfee610-b7fd06d000005bdb-70-50b4130dc8f3
Date: Tue, 27 Nov 2012 01:10:37 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 1/5] backlight: Add GPIO-based backlight driver
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
X-MTR: 20121127010645680@jg1.han
Msgkey: 20121127010645680@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121127010645680@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <33110366.44811353978636788.JavaMail.weblogic@epv6ml07>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zY11e4S0BBicnW1tc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMaP+9jaVgikTFmglrWRoYD4h3MXJyCAkoSUw6uZcRxJYQMJHY9P4T
	K4QtJnHh3no2iJpljBKLJ9XD1EyethCongsoPp9R4tm2T8wgCRYBVYn7X9eANbAJqEtM+N3M
	AmILCzhLTL37jR3EFhFwkrjdvIwJpJlZYBqzxLu7t6E2yErcmzwbbBCvgKDEyZlPgJo5gLYp
	SHxp1oMIK0pcPj2VGeIICYk79/dDHcorMaP9KQuELScx7esaqBppifOzNjDCPLP4+2OoOL/E
	sds7mCDG80o8uR8MM2b35i9sELaAxNQzBxkhSlQlGq/XQYT5JNYsfAu1SVDi9LVuZpjWho2/
	wT5kBrpySvdDKFtL4suPfWyongKxnSUW/H3ENIFReRaS1Cwk7bOQtCOrWcDIsopRNLUguaA4
	KT3VDDmuNzFCkqDADsYlDRaHGAU4GJV4eBXWbQ4QYk0sK67MPcQowcGsJMI7jW1LgBBvSmJl
	VWpRfnxRaU5q8SHGiYzACJzILCWanA9M0Xkl8YbGxiZmJqYm5pam5qbECJsbmRoA06+BIYnC
	SuK87BXTA4QE0hNLUrNTUwtSi2COYuLglGpg1D0/pXz2k9vff31/zeKz23N9m2HnP4ZPKyK2
	REc8e7CiXStn7ktNHo45be/j/+jk7tqzNbHMaOM3YZn78YI1cw4sim0S/bFrUVnHBePoR0Vu
	THd3XW6/sUjM0NT/brG3ZalG9sOqp0G/Tbxcs8KepO3dKjEn/HxOydanjpM2/P21172/W/z4
	HCWW4oxEQy3mouJEAJChRsX1AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/t6bq8wlsCDGb+NbO4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnrGlrFWhgYGRqZAVQkZ
	Ge2/t7EUTJGoWDNhLUsD4wHxLkZODiEBJYlJJ/cygtgSAiYSk6cthLLFJC7cW8/WxcgFVDOf
	UeLZtk/MIAkWAVWJ+1/XsIHYbALqEhN+N7OA2MICzhJT735jB7FFBJwkbjcvYwJpZhaYxizx
	7u5tNohtshL3Js8GG8QrIChxcuYToGYOoG0KEl+a9SDCihKXT09lhjhCQuLO/f2sEDavxIz2
	pywQtpzEtK9roGqkJc7P2gB39OLvj6Hi/BLHbu9gghjPK/HkfjDMmN2bv7BB2AISU88cZIQo
	UZVovF4HEeaTWLPwLdQmQYnT17qZYVobNv4G+5AZ6Mop3Q+hbC2JLz/2saF6CsR2lljw9xHT
	BEa5WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9FQzveLE3OLSvHS95PzcTYzgBPVMYAfjkgaL
	Q4wCHIxKPLwK6zYHCLEmlhVX5h5ilOBgVhLhnca2JUCINyWxsiq1KD++qDQntfgQow8w/iYy
	S4km5wOTZ15JvKGxsYmZiam5gYWBpTkOYSVxXvaK6QFCAumJJanZqakFqUUw45g4OKUaGPWF
	TOeHPXjTtE//8IFQzo7zq+r2R5wLXjRr8XPJp3N+b3WbcG5qy6b3qxLMzI2m798mc6lpmeli
	zZjv5ZE756aw73+UdVM24ZPY796FfUUz4+1039R1rpDrb2l5aWjjPunQldRFvgffbGup23lf
	KP6eTOhlP51ejq0drLabQ0IWs/zoroue+EqJpTgj0VCLuag4EQD0leNAfQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAR1Aijp030087

On Saturday, November 24, 2012 1:35 AM, Laurent Pinchart wrote
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/video/backlight/Kconfig          |    7 ++
>  drivers/video/backlight/Makefile         |    1 +
>  drivers/video/backlight/gpio_backlight.c |  158 ++++++++++++++++++++++++++++++
>  include/video/gpio_backlight.h           |   21 ++++
>  4 files changed, 187 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/backlight/gpio_backlight.c
>  create mode 100644 include/video/gpio_backlight.h

[...]

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

Please use GPIOF_INIT flags if you want to turn off GPIO backlight.
If gbl->active is inverted, GPIOF_INIT_HIGH can be used as below:

	ret = devm_gpio_request_one(gbl->dev, gbl->gpio,
				    GPIOF_DIR_OUT | (gbl->active ?
				    GPIOF_INIT_LOW : GPIOF_INIT_HIGH),
				    pdata->name);

Best regards,
Jingoo Han

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


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
