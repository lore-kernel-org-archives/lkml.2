Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992585Ab2KOBaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:30:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58225 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992522Ab2KOBaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:30:14 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d7-50a445a4acd4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
In-reply-to: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
Subject: Re: [PATCH] backlight: Add of_find_backlight_by_node() function
Date: Thu, 15 Nov 2012 10:30:11 +0900
Message-id: <004201cdc2d0$c1920210$44b60630$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2+g0iAWySaBkDDQt6otgruBRgKJgETNj4g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zY90lrksCDDY+E7Y40feB1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWc6mhgLFgrVPHm0wG2BsbJ/F2MnBwSAiYSbVvvM0PY
	YhIX7q1nA7GFBJYxSizYHwtTs/PCIaAaLqD4dEaJc7tPMEE4vxgl3q7uAOtgE1CT+PLlMDuI
	LSKQJjFvWx8LSBGzwDFGifXrbjBCjPWXeNS6nAXE5hQIkPj84ytYXFjAQ2Lz5a9gg1gEVCU+
	rJoCVMPBwStgK7F7QhRImFdAUOLH5HtgrcwCWhLrdx5ngrDlJTavecsMUi4hoC7x6K8uiCki
	YCSxY4cbRIWIxL4X7xghhgtIfJt8iAWiWlZi0wGwtyQENrFLnP15jw3iX0mJgytusExglJiF
	ZPEsJItnIVk8C8mKBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzFCIkx6B+OqBotDjAIc
	jEo8vBYfFwcIsSaWFVfmHmKU4GBWEuF9cRAoxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnA
	6M8riTc0NjYxMzE1Mbc0NTfFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgXHpgtd/Tt+P
	nRUn7uUhb7Y5c0mA8O+J/r/Ct16UED548FWJhczST3XcFdn9burcIWpVH30uylr0/Y83OV1Q
	GyK10bn+2vlFLDMU/u67OP1w9M6ZJi8eXv288dzPDzJ6FrP7Y3wLv0x+YcXD9t3u6bnDeaJ/
	1/xYtXBZhJLjrrrgdRMMVeXsVCqUWIozEg21mIuKEwEsl7mS3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd0lrksCDHa/57U40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmnOpoYCxYK1Tx
	5tMBtgbGyfxdjJwcEgImEjsvHGKGsMUkLtxbz9bFyMUhJDCdUeLc7hNMEM4vRom3qzvYQKrY
	BNQkvnw5zA5iiwikSczb1scCUsQscIxRYv26G4wgCSEBf4lHrctZQGxOgQCJzz++gsWFBTwk
	Nl/+CjaIRUBV4sOqKUA1HBy8ArYSuydEgYR5BQQlfky+B9bKLKAlsX7ncSYIW15i85q3zCDl
	EgLqEo/+6oKYIgJGEjt2uEFUiEjse/GOcQKj0Cwkg2YhGTQLyaBZSFoWMLKsYhRNLUguKE5K
	zzXSK07MLS7NS9dLzs/dxAiO4GfSOxhXNVgcYhTgYFTi4bX4uDhAiDWxrLgy9xCjBAezkgjv
	i4NAId6UxMqq1KL8+KLSnNTiQ4w+QG9OZJYSTc4HJpe8knhDYxMzI0sjMwsjE3NzHMJK4rzN
	HikBQgLpiSWp2ampBalFMOOYODilGhhli5d283nWfN8+yfmK/KnUE5dD/nzV2yfotW1aW+fS
	A44HS5NmnZsfZWLGpJXwT2rLoZ12B/5uCU0/bWETmHtlu+VxxiNfDQ8FTl+fv+XV62eaku84
	lt36+qLtY9RKMQXJtUdnJQrFOsrJrDq3ZWlvxKe35XkinhXZszlP9WvqFZdeZcv5VFqixFKc
	kWioxVxUnAgA6lv//g0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 09, 2012 11:05 PM Thierry Reding wrote
> 
> This function finds the struct backlight_device for a given device tree
> node. A dummy function is provided so that it safely compiles out if OF
> support is disabled.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

CC'ed Andrew Morton

Hi Thierry Reding,

The patch itself looks good.
Could you explain when this API is used?
Thank you.


Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/backlight.c | 17 +++++++++++++++++
>  include/linux/backlight.h           | 10 ++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 297db2f..0d1ed4f 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -370,6 +370,23 @@ void backlight_device_unregister(struct backlight_device *bd)
>  }
>  EXPORT_SYMBOL(backlight_device_unregister);
> 
> +#if IS_ENABLED(CONFIG_OF)
> +static int of_parent_match(struct device *dev, void *data)
> +{
> +	return dev->parent && dev->parent->of_node == data;
> +}
> +
> +struct backlight_device *of_find_backlight_by_node(struct device_node *node)
> +{
> +	struct device *dev;
> +
> +	dev = class_find_device(backlight_class, NULL, node, of_parent_match);
> +
> +	return dev ? to_backlight_device(dev) : NULL;
> +}
> +EXPORT_SYMBOL(of_find_backlight_by_node);
> +#endif
> +
>  static void __exit backlight_class_exit(void)
>  {
>  	class_destroy(backlight_class);
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index 5ffc6dd..11840e9 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -134,4 +134,14 @@ struct generic_bl_info {
>  	void (*kick_battery)(void);
>  };
> 
> +#if IS_ENABLED(CONFIG_OF)
> +struct backlight_device *of_find_backlight_by_node(struct device_node *node);
> +#else
> +static inline struct backlight_device *
> +of_find_backlight_by_node(struct device_node *node)
> +{
> +	return NULL;
> +}
> +#endif
> +
>  #endif
> --
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

