Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2CVGMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 02:12:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2962 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2CVGMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 02:12:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 21 Mar 2012 23:12:28 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 22 Mar 2012 11:42:25 +0530
Subject: RE: [PATCH] mfd: Move MFD_TPS65090 and TPS65911_COMPARATOR Kconfig
 entries to proper location
Thread-Topic: [PATCH] mfd: Move MFD_TPS65090 and TPS65911_COMPARATOR Kconfig
 entries to proper location
Thread-Index: Ac0H0TENwEc3yRlMT3m/ngMVsB5vrQAIUddg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3127F99@BGMAIL02.nvidia.com>
References: <1332382320.13011.1.camel@phoenix>
In-Reply-To: <1332382320.13011.1.camel@phoenix>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2M6CdGx017838

Looks good to me.
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Thursday, March 22, 2012 7:42 AM
> To: linux-kernel@vger.kernel.org
> Cc: Jorge Eduardo Candelaria; Venu Byravarasu; Samuel Ortiz
> Subject: [PATCH] mfd: Move MFD_TPS65090 and TPS65911_COMPARATOR
> Kconfig entries to proper location
> 
> Group all TPSxxxx drivers together and sort by alphabetical order.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/Kconfig |   30 +++++++++++++++---------------
>  1 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 29f463c..f9e0353 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -143,6 +143,18 @@ config TPS6507X
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called tps6507x.
> 
> +config MFD_TPS65090
> +	bool "TPS65090 Power Management chips"
> +	depends on I2C=y && GENERIC_HARDIRQS
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	help
> +	  If you say yes here you get support for the TPS65090 series of
> +	  Power Management chips.
> +	  This driver provides common support for accessing the device,
> +	  additional drivers must be enabled in order to use the
> +	  functionality of the device.
> +
>  config MFD_TPS65217
>  	tristate "TPS65217 Power Management / White LED chips"
>  	depends on I2C
> @@ -182,6 +194,9 @@ config MFD_TPS65910
>  	  if you say yes here you get support for the TPS65910 series of
>  	  Power Management chips.
> 
> +config TPS65911_COMPARATOR
> +	tristate
> +
>  config MFD_TPS65912
>  	bool
>  	depends on GPIOLIB
> @@ -825,21 +840,6 @@ config MFD_PM8XXX_IRQ
>  	  This is required to use certain other PM 8xxx features, such as GPIO
>  	  and MPP.
> 
> -config TPS65911_COMPARATOR
> -	tristate
> -
> -config MFD_TPS65090
> -	bool "TPS65090 Power Management chips"
> -	depends on I2C=y && GENERIC_HARDIRQS
> -	select MFD_CORE
> -	select REGMAP_I2C
> -	help
> -	  If you say yes here you get support for the TPS65090 series of
> -	  Power Management chips.
> -	  This driver provides common support for accessing the device,
> -	  additional drivers must be enabled in order to use the
> -	  functionality of the device.
> -
>  config MFD_AAT2870_CORE
>  	bool "Support for the AnalogicTech AAT2870"
>  	select MFD_CORE
> --
> 1.7.5.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
