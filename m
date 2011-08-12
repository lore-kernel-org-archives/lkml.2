Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1HLI0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:26:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20579 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1HLI0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:26:12 -0400
X-AuditID: cbfee61b-b7c3dae000002cb8-f8-4e44e3a00d63
Date: Fri, 12 Aug 2011 17:26:06 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] ARM: EXYNOS4: Update config file of NURI to enable RTC
In-reply-to: <4E27FEBC.7050302@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'linux-arm-kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Message-id: <006201cc58c9$7c7b7c00$75727400$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcxHkI1lHnFCLS3DT6KkIbqpakNXFgRONUlA
References: <4E27FEBC.7050302@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
> This patch update config file of NURI board to enable RTC
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos4/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
> index b735705..bb675fb 100644
> --- a/arch/arm/mach-exynos4/Kconfig
> +++ b/arch/arm/mach-exynos4/Kconfig
> @@ -184,6 +184,7 @@ config MACH_NURI
>  	bool "Mobile NURI Board"
>  	select CPU_EXYNOS4210
>  	select S3C_DEV_WDT
> +	select S3C_DEV_RTC
>  	select S3C_DEV_HSMMC
>  	select S3C_DEV_HSMMC2
>  	select S3C_DEV_HSMMC3
> --
> 1.7.0.4

Applied, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

