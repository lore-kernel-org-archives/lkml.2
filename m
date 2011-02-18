Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab1BRJIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:08:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44572 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab1BRJIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:08:30 -0500
Date: Fri, 18 Feb 2011 18:05:54 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] ARM: SAMSUNG: Drop exporting s3c24xx_ts_set_platdata
In-reply-to: <1297651767.13143.3.camel@mola>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-id: <01ff01cbcf4b$0e162420$2a426c60$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvL8XkhqmTZiejAQ+GlgRl6ho2tTADWVnGw
References: <1297651767.13143.3.camel@mola>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> 
> s3c24xx_ts_set_platdata is annotated __init and not used by any module,
> thus don't export it.
> This patch fixes below warning:
> 
> WARNING: arch/arm/plat-samsung/built-in.o(__ksymtab+0x90): Section
mismatch
> in reference from the variable __ksymtab_s3c24xx_ts_set_platdata to the
> function .init.text:s3c24xx_ts_set_platdata()
> The symbol s3c24xx_ts_set_platdata is exported and annotated __init
> Fix this by removing the __init annotation of s3c24xx_ts_set_platdata or
drop
> the export.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/plat-samsung/dev-ts.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/dev-ts.c
b/arch/arm/plat-samsung/dev-ts.c
> index 236ef84..3e4bd81 100644
> --- a/arch/arm/plat-samsung/dev-ts.c
> +++ b/arch/arm/plat-samsung/dev-ts.c
> @@ -58,4 +58,3 @@ void __init s3c24xx_ts_set_platdata(struct
> s3c2410_ts_mach_info *pd)
> 
>  	s3c_device_ts.dev.platform_data = npd;
>  }
> -EXPORT_SYMBOL(s3c24xx_ts_set_platdata);
> --
> 1.7.2
> 
Ok, applied.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

