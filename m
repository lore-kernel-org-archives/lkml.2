Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0F3SYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:24:18 -0400
Received: from smtp.nokia.com ([192.100.122.233]:43587 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0F3SYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:24:16 -0400
Date: Wed, 30 Jun 2010 21:23:46 +0300 (EEST)
Message-Id: <20100630.212346.226780589.Hiroshi.DOYU@nokia.com>
To: siccegge@cs.fau.de, h-kanigeri2@ti.com
Cc: tony@atomide.com, linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 22/33] Removing dead MPU_{BRIDGE,TESLA}_IOMMU
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <fcfa44a43c21c70f89ced96b96d7c1489d28cc51.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<fcfa44a43c21c70f89ced96b96d7c1489d28cc51.1277911346.git.siccegge@cs.fau.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jun 2010 18:23:51.0994 (UTC) FILETIME=[642141A0:01CB1881]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ext Christoph Egger <siccegge@cs.fau.de>
Subject: [PATCH 22/33] Removing dead MPU_{BRIDGE,TESLA}_IOMMU
Date: Wed, 30 Jun 2010 18:01:01 +0200

> MPU_{BRIDGE,TESLA}_IOMMU doesn't exist in Kconfig, therefore removing
> all references for it from the source code.

Coming soon, I guess. Hari?

> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-omap2/omap-iommu.c |   22 ----------------------
>  1 files changed, 0 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
> index eb9bee7..3aa3fe9 100644
> --- a/arch/arm/mach-omap2/omap-iommu.c
> +++ b/arch/arm/mach-omap2/omap-iommu.c
> @@ -35,17 +35,6 @@ static struct iommu_device omap3_devices[] = {
>  			.clk_name = "cam_ick",
>  		},
>  	},
> -#if defined(CONFIG_MPU_BRIDGE_IOMMU)
> -	{
> -		.base = 0x5d000000,
> -		.irq = 28,
> -		.pdata = {
> -			.name = "iva2",
> -			.nr_tlb_entries = 32,
> -			.clk_name = "iva2_ck",
> -		},
> -	},
> -#endif
>  };
>  #define NR_OMAP3_IOMMU_DEVICES ARRAY_SIZE(omap3_devices)
>  static struct platform_device *omap3_iommu_pdev[NR_OMAP3_IOMMU_DEVICES];
> @@ -66,17 +55,6 @@ static struct iommu_device omap4_devices[] = {
>  			.clk_name = "ducati_ick",
>  		},
>  	},
> -#if defined(CONFIG_MPU_TESLA_IOMMU)
> -	{
> -		.base = OMAP4_MMU2_BASE,
> -		.irq = INT_44XX_DSP_MMU,
> -		.pdata = {
> -			.name = "tesla",
> -			.nr_tlb_entries = 32,
> -			.clk_name = "tesla_ick",
> -		},
> -	},
> -#endif
>  };
>  #define NR_OMAP4_IOMMU_DEVICES ARRAY_SIZE(omap4_devices)
>  static struct platform_device *omap4_iommu_pdev[NR_OMAP4_IOMMU_DEVICES];
> -- 
> 1.7.0.4
> 
