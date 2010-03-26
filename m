Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0CZRGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:06:04 -0400
Received: from mga06.intel.com ([134.134.136.21]:22352 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750925Ab0CZRGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:06:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,315,1267430400"; 
   d="scan'208";a="607973479"
Date: Fri, 26 Mar 2010 18:06:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Remove unused wm831x IRQ handler data
Message-ID: <20100326170646.GE3237@sortiz.org>
References: <1269614824-29056-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269614824-29056-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Mar 26, 2010 at 02:47:04PM +0000, Mark Brown wrote:
> This was used by the old, pre-genirq IRQ implementation but is no
> longer required.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Thanks, patch applied.

Cheers,
Samuel.


> ---
>  drivers/mfd/wm831x-irq.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
> index 3013276..b1d66b8 100644
> --- a/drivers/mfd/wm831x-irq.c
> +++ b/drivers/mfd/wm831x-irq.c
> @@ -38,8 +38,6 @@ struct wm831x_irq_data {
>  	int primary;
>  	int reg;
>  	int mask;
> -	irq_handler_t handler;
> -	void *handler_data;
>  };
>  
>  static struct wm831x_irq_data wm831x_irqs[] = {
> -- 
> 1.7.0.2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
