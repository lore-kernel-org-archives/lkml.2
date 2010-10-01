Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0JAJcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:32:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45271 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab0JAJcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:32:53 -0400
From: "Marathe, Yogesh" <yogesh_marathe@ti.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>
CC: "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 1 Oct 2010 15:02:42 +0530
Subject: RE: [PATCH 1/4] iommu: remove CONFIG_MPU_BRIDGE_IOMMU
Thread-Topic: [PATCH 1/4] iommu: remove CONFIG_MPU_BRIDGE_IOMMU
Thread-Index: ActhFHAvoISiTxAwSQ2kZuuZXu0mxQALAsvw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593023412B188@dbde02.ent.ti.com>
References: <1285902536-7043-1-git-send-email-x0095840@ti.com>
 <1285902536-7043-2-git-send-email-x0095840@ti.com>
In-Reply-To: <1285902536-7043-2-git-send-email-x0095840@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Guzman Lugo, Fernando
> Sent: Friday, October 01, 2010 8:39 AM
> To: Hiroshi.DOYU@nokia.com
> Cc: felipe.contreras@nokia.com; ameya.palande@nokia.com; linux-
> kernel@vger.kernel.org; andy.shevchenko@gmail.com; linux-
> omap@vger.kernel.org; Guzman Lugo, Fernando
> Subject: [PATCH 1/4] iommu: remove
> CONFIG_MPU_BRIDGE_IOMMU
> 
> remove CONFIG_MPU_BRIDGE_IOMMU in order to create
> iommu_device
> for iva2.
> 
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> ---
>  arch/arm/mach-omap2/omap-iommu.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-
> omap2/omap-iommu.c
> index f5a1aad..bb8c01d 100644
> --- a/arch/arm/mach-omap2/omap-iommu.c
> +++ b/arch/arm/mach-omap2/omap-iommu.c
> @@ -35,7 +35,6 @@ static struct iommu_device omap3_devices[] = {
>  			.clk_name = "cam_ick",
>  		},
>  	},
> -#if defined(CONFIG_MPU_BRIDGE_IOMMU)
>  	{
>  		.base = 0x5d000000,
>  		.irq = 28,
> @@ -45,7 +44,6 @@ static struct iommu_device omap3_devices[] = {
>  			.clk_name = "iva2_ck",
>  		},
>  	},
> -#endif
>  };
>  #define NR_OMAP3_IOMMU_DEVICES
> ARRAY_SIZE(omap3_devices)
>  static struct platform_device
> *omap3_iommu_pdev[NR_OMAP3_IOMMU_DEVICES];
> --
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Fernando,

I have already submitted this patch and it is being discussed here.
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg35615.html

Regards,
Yogesh.

