Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0KMIB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 03:01:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56614 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0KMIBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 03:01:55 -0500
Date: Sat, 13 Nov 2010 17:02:16 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] arm: Fix HAVE_S3C2410_WATCHDOG warnings
In-reply-to: <20101104081633.GA27129@july>
To: "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Message-id: <000101cb8309$18eb28c0$4ac17a40$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Act7+sLGO58uQp0yTpixC+r0lba8CQHByIHQ
References: <20101104081633.GA27129@july>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> 
> Fix build warnings
> warning: (ARCH_S3C64XX && <choice> && WATCHDOG || ARCH_S5P64X0 && <choice>
&&
> WATCHDOG || ARCH_S5P6442 && <choice> && WATCHDOG || ARCH_S5PC100 &&
<choice>
> || ARCH_S5PV210 && <choice> || ARCH_S5PV310 && <choice> || MACH_SMDK6410
&&
> ARCH_S3C64XX) selects HAVE_S3C2410_WATCHDOG which has unmet direct
> dependencies (WATCHDOG)
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a19a526..a302713 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -677,7 +677,7 @@ config ARCH_S3C64XX
>  	select USB_ARCH_HAS_OHCI
>  	select SAMSUNG_GPIOLIB_4BIT
>  	select HAVE_S3C2410_I2C
> -	select HAVE_S3C2410_WATCHDOG
> +	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	help
>  	  Samsung S3C64XX series based systems
> 
> @@ -686,7 +686,7 @@ config ARCH_S5P64X0
>  	select CPU_V6
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> -	select HAVE_S3C2410_WATCHDOG
> +	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	select ARCH_USES_GETTIMEOFFSET
>  	select HAVE_S3C2410_I2C
>  	select HAVE_S3C_RTC
> @@ -700,7 +700,7 @@ config ARCH_S5P6442
>  	select GENERIC_GPIO
>  	select HAVE_CLK
>  	select ARCH_USES_GETTIMEOFFSET
> -	select HAVE_S3C2410_WATCHDOG
> +	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	help
>  	  Samsung S5P6442 CPU based systems
> 
> @@ -713,7 +713,7 @@ config ARCH_S5PC100
>  	select ARCH_USES_GETTIMEOFFSET
>  	select HAVE_S3C2410_I2C
>  	select HAVE_S3C_RTC
> -	select HAVE_S3C2410_WATCHDOG
> +	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	help
>  	  Samsung S5PC100 series based systems
> 
> @@ -728,7 +728,7 @@ config ARCH_S5PV210
>  	select ARCH_USES_GETTIMEOFFSET
>  	select HAVE_S3C2410_I2C
>  	select HAVE_S3C_RTC
> -	select HAVE_S3C2410_WATCHDOG
> +	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	help
>  	  Samsung S5PV210/S5PC110 series based systems
> 
> @@ -741,7 +741,7 @@ config ARCH_S5PV310
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_S3C_RTC
>  	select HAVE_S3C2410_I2C
> -	select HAVE_S3C2410_WATCHDOG
> +	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	help
>  	  Samsung S5PV310 series based systems

Ok, will apply...
And will sort out other similar configure warning such as I2C and RTC.

As a note, in your patch, my e-mail address was wrong :-(

Anyway,
Thanks.

Have a nice weekend.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

