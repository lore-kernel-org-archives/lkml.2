Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab1KJJvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:51:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:9869 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933773Ab1KJJvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:51:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,488,1315206000"; 
   d="scan'208";a="72833249"
Subject: Re: [PATCH] dma: fix spacing for method declaration, coding style
 issue in iop-adma.c
From: Vinod Koul <vinod.koul@intel.com>
To: Ciaran McCormick <ciaranmccormick@gmail.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <1320089366-13300-1-git-send-email-ciaranmccormick@gmail.com>
References: <1320089366-13300-1-git-send-email-ciaranmccormick@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 15:17:08 +0530
Message-ID: <1320918428.32205.1207.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 19:29 +0000, Ciaran McCormick wrote:
> From: Ciaran McCormick <ciaranmccormick@gmail.com>
> 
> ---
>  drivers/dma/iop-adma.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
> index e03f811..686dc76 100644
> --- a/drivers/dma/iop-adma.c
> +++ b/drivers/dma/iop-adma.c
> @@ -1746,12 +1746,12 @@ static struct platform_driver iop_adma_driver = {
>  	},
>  };
>  
> -static int __init iop_adma_init (void)
> +static int __init iop_adma_init(void)
>  {
>  	return platform_driver_register(&iop_adma_driver);
>  }
>  
> -static void __exit iop_adma_exit (void)
> +static void __exit iop_adma_exit(void)
>  {
>  	platform_driver_unregister(&iop_adma_driver);
>  	return;
Applied thanks

-- 
~Vinod

