Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2FTFPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:15:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64094 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2FTFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:15:35 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-60-4fe15c7590ce
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1339616647.30984.174.camel@x61.thuisdomein>
In-reply-to: <1339616647.30984.174.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: remove unused SPI clock headers
Date: Wed, 20 Jun 2012 14:15:32 +0900
Message-id: <029101cd4ea3$b744fd40$25cef7c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JnOdsfTyGdSOtSkeRdqBkb6b1RwFBQ7Tg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd3SmIf+BpdbVC0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKeHTEseGdYcfLGefYGxtuaXYycHBICJhL3GnqYIGwx
	iQv31rN1MXJxCAksYpS4M20LlPOXUWLLgn/sIFVsAhoSh98/A7NFBIolzv14xdjFyMHBLJAt
	seUV2CAhAQuJs4/PgNmcApYSv3/uYAEpEQayG27zgIRZBFQlbva3soDYvAK2EnNmf2ODsAUl
	fky+BxZnFlCXmDRvETOELS+xec1bZpAxEkDxR391IQ4wktjfuhyqXERi34t3jBMYhWYhmTQL
	yaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwMD+T2sG4ssHiEKMAB6MS
	D++JwIf+QqyJZcWVuYcYJTiYlUR4+7888BfiTUmsrEotyo8vKs1JLT7EKM3BoiTO22R9wV9I
	ID2xJDU7NbUgtQgmy8TBKdXAuMJf1i30xBGFHQpH/sxuEllUo3m0lF2wL0SbXST2+vJPt41O
	PC6NNNmjtMJLIlJWtv7QrkbHvU2uP89kOZ/8K/Bm+9ZS8aBs9Zgtx5U9PsWnRPzYK73XgWvv
	tJme18XPnj/ftKpUYlpPgepibrfHGZMZjrd8TObSdqis4eFcasuxzfnc17XMSizFGYmGWsxF
	xYkAWBoOMGICAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Commit 875a59374cd10200ac24f03877ccd8f73af590cc ("ARM: SAMSUNG:
> Consolidation of SPI platform devices to plat-samsung") deleted all
> (four) files that included one of the "spi-clocks.h" headers. It seems
> it was just an oversight to not remove those headers too. They can
> safely be removed now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Only tested by using various git commands on the (history of the)
> tree.
> 
> 1) The history of arch/arm/mach-exynos/include/mach/spi-clocks.h
> actually differs from the history of the other four headers. It got
> added by commit 74ac23a3e4962bf4f935a5579ae08754d21f9d5a ("ARM: EXYNOS:
> Modified files for SPI consolidation work"). That commit actually got
> added (very shortly) after commit
> 875a59374cd10200ac24f03877ccd8f73af590cc removed all files that included
> spi-clocks.h.
> 
>  arch/arm/mach-exynos/include/mach/spi-clocks.h  |   16 ----------------
>  arch/arm/mach-s3c64xx/include/mach/spi-clocks.h |   18 ------------------
>  arch/arm/mach-s5p64x0/include/mach/spi-clocks.h |   20 -------------------
> -
>  arch/arm/mach-s5pc100/include/mach/spi-clocks.h |   18 ------------------
>  arch/arm/mach-s5pv210/include/mach/spi-clocks.h |   17 -----------------
>  5 files changed, 0 insertions(+), 89 deletions(-)
>  delete mode 100644 arch/arm/mach-exynos/include/mach/spi-clocks.h
>  delete mode 100644 arch/arm/mach-s3c64xx/include/mach/spi-clocks.h
>  delete mode 100644 arch/arm/mach-s5p64x0/include/mach/spi-clocks.h
>  delete mode 100644 arch/arm/mach-s5pc100/include/mach/spi-clocks.h
>  delete mode 100644 arch/arm/mach-s5pv210/include/mach/spi-clocks.h
> 
> diff --git a/arch/arm/mach-exynos/include/mach/spi-clocks.h
> b/arch/arm/mach-exynos/include/mach/spi-clocks.h
> deleted file mode 100644
> index c71a5fb..0000000
> --- a/arch/arm/mach-exynos/include/mach/spi-clocks.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -/* linux/arch/arm/mach-exynos4/include/mach/spi-clocks.h
> - *
> - * Copyright (C) 2011 Samsung Electronics Co. Ltd.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef __ASM_ARCH_SPI_CLKS_H
> -#define __ASM_ARCH_SPI_CLKS_H __FILE__
> -
> -/* Must source from SCLK_SPI */
> -#define EXYNOS_SPI_SRCCLK_SCLK		0
> -
> -#endif /* __ASM_ARCH_SPI_CLKS_H */
> diff --git a/arch/arm/mach-s3c64xx/include/mach/spi-clocks.h
> b/arch/arm/mach-s3c64xx/include/mach/spi-clocks.h
> deleted file mode 100644
> index 9d0c43b..0000000
> --- a/arch/arm/mach-s3c64xx/include/mach/spi-clocks.h
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -/* linux/arch/arm/mach-s3c64xx/include/mach/spi-clocks.h
> - *
> - * Copyright (C) 2009 Samsung Electronics Ltd.
> - *	Jaswinder Singh <jassi.brar@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef __S3C64XX_PLAT_SPI_CLKS_H
> -#define __S3C64XX_PLAT_SPI_CLKS_H __FILE__
> -
> -#define S3C64XX_SPI_SRCCLK_PCLK		0
> -#define S3C64XX_SPI_SRCCLK_SPIBUS	1
> -#define S3C64XX_SPI_SRCCLK_48M		2
> -
> -#endif /* __S3C64XX_PLAT_SPI_CLKS_H */
> diff --git a/arch/arm/mach-s5p64x0/include/mach/spi-clocks.h
> b/arch/arm/mach-s5p64x0/include/mach/spi-clocks.h
> deleted file mode 100644
> index 170a20a..0000000
> --- a/arch/arm/mach-s5p64x0/include/mach/spi-clocks.h
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -/* linux/arch/arm/mach-s5p64x0/include/mach/spi-clocks.h
> - *
> - * Copyright (c) 2010 Samsung Electronics Co., Ltd.
> - *		http://www.samsung.com
> - *
> - * Copyright (C) 2010 Samsung Electronics Co. Ltd.
> - *	Jaswinder Singh <jassi.brar@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> -*/
> -
> -#ifndef __ASM_ARCH_SPI_CLKS_H
> -#define __ASM_ARCH_SPI_CLKS_H __FILE__
> -
> -#define S5P64X0_SPI_SRCCLK_PCLK		0
> -#define S5P64X0_SPI_SRCCLK_SCLK		1
> -
> -#endif /* __ASM_ARCH_SPI_CLKS_H */
> diff --git a/arch/arm/mach-s5pc100/include/mach/spi-clocks.h
> b/arch/arm/mach-s5pc100/include/mach/spi-clocks.h
> deleted file mode 100644
> index 65e4263..0000000
> --- a/arch/arm/mach-s5pc100/include/mach/spi-clocks.h
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -/* linux/arch/arm/mach-s5pc100/include/mach/spi-clocks.h
> - *
> - * Copyright (C) 2010 Samsung Electronics Co. Ltd.
> - *	Jaswinder Singh <jassi.brar@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef __S5PC100_PLAT_SPI_CLKS_H
> -#define __S5PC100_PLAT_SPI_CLKS_H __FILE__
> -
> -#define S5PC100_SPI_SRCCLK_PCLK		0
> -#define S5PC100_SPI_SRCCLK_48M		1
> -#define S5PC100_SPI_SRCCLK_SPIBUS	2
> -
> -#endif /* __S5PC100_PLAT_SPI_CLKS_H */
> diff --git a/arch/arm/mach-s5pv210/include/mach/spi-clocks.h
> b/arch/arm/mach-s5pv210/include/mach/spi-clocks.h
> deleted file mode 100644
> index 02acded..0000000
> --- a/arch/arm/mach-s5pv210/include/mach/spi-clocks.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -/* linux/arch/arm/mach-s5pv210/include/mach/spi-clocks.h
> - *
> - * Copyright (C) 2010 Samsung Electronics Co. Ltd.
> - *	Jaswinder Singh <jassi.brar@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef __S5PV210_PLAT_SPI_CLKS_H
> -#define __S5PV210_PLAT_SPI_CLKS_H __FILE__
> -
> -#define S5PV210_SPI_SRCCLK_PCLK		0
> -#define S5PV210_SPI_SRCCLK_SCLK		1
> -
> -#endif /* __S5PV210_PLAT_SPI_CLKS_H */
> --
> 1.7.7.6

Yes, looks ok to me and will apply this into cleanup branch.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

