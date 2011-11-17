Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1KQJHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:07:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:50276 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab1KQJHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:07:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,525,1315206000"; 
   d="scan'208";a="38171810"
Subject: Re: [PATCH 1/2 v2] pch_dma: Change company name OKI SEMICONDUCTOR
 to LAPIS Semiconductor
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
In-Reply-To: <1321514063-14064-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321514063-14064-1-git-send-email-tomoya.rohm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 14:32:30 +0530
Message-ID: <1321520550.1516.186.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:14 +0900, Tomoya MORINAGA wrote:
> On October 1 in 2011,
> OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor
> Co., Ltd.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Applied both, Thanks

> ---
>  drivers/dma/Kconfig   |    4 ++--
>  drivers/dma/pch_dma.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index ab8f469..495e841 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -201,13 +201,13 @@ config PL330_DMA
>  	  platform_data for a dma-pl330 device.
>  
>  config PCH_DMA
> -	tristate "Intel EG20T PCH / OKI Semi IOH(ML7213/ML7223) DMA support"
> +	tristate "Intel EG20T PCH / LAPIS Semi IOH(ML7213/ML7223) DMA support"
>  	depends on PCI && X86
>  	select DMA_ENGINE
>  	help
>  	  Enable support for Intel EG20T PCH DMA engine.
>  
> -	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
> +	  This driver also can be used for LAPIS Semiconductor IOH(Input/
>  	  Output Hub), ML7213 and ML7223.
>  	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
>  	  for MP(Media Phone) use.
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index a6d0e3d..a9b8a79 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -1,7 +1,7 @@
>  /*
>   * Topcliff PCH DMA controller driver
>   * Copyright (c) 2010 Intel Corporation
> - * Copyright (C) 2011 OKI SEMICONDUCTOR CO., LTD.
> + * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -1057,7 +1057,7 @@ static void __exit pch_dma_exit(void)
>  module_init(pch_dma_init);
>  module_exit(pch_dma_exit);
>  
> -MODULE_DESCRIPTION("Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 IOH "
> +MODULE_DESCRIPTION("Intel EG20T PCH / LAPIS Semiconductor ML7213/ML7223 IOH "
>  		   "DMA controller driver");
>  MODULE_AUTHOR("Yong Wang <yong.y.wang@intel.com>");
>  MODULE_LICENSE("GPL v2");


-- 
~Vinod

