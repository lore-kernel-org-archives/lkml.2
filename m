Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2INDNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:13:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:36281 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab2INDNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:13:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="221876327"
Subject: Re: [PATCH] dma: ipu: Drop unused spinlock
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Dan Williams <djbw@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>
In-Reply-To: <20120906091935.64c851ac@endymion.delvare>
References: <20120906091935.64c851ac@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 08:40:12 +0530
Message-ID: <1347592212.1943.15.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 09:19 +0200, Jean Delvare wrote:
> I was checking why this spinlock was never initialized, but it turns
> out it's not used anywhere, so we can drop it.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> ---
> I can't even build-test this.
> 
>  drivers/dma/ipu/ipu_irq.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- linux-3.6-rc4.orig/drivers/dma/ipu/ipu_irq.c	2012-08-04 21:49:26.000000000 +0200
> +++ linux-3.6-rc4/drivers/dma/ipu/ipu_irq.c	2012-09-06 09:13:31.034228670 +0200
> @@ -45,7 +45,6 @@ static void ipu_write_reg(struct ipu *ip
>  struct ipu_irq_bank {
>  	unsigned int	control;
>  	unsigned int	status;
> -	spinlock_t	lock;
>  	struct ipu	*ipu;
>  };
>  
Dan, you okay with this?



-- 
~Vinod

