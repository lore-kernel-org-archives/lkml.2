Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2AOLQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 06:16:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33600 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab2AOLQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 06:16:11 -0500
Date: Sun, 15 Jan 2012 03:15:55 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jhbird.choi@samsung.com, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] mfd: variable dereferenced before check
Message-ID: <20120115111553.GA3040@opensource.wolfsonmicro.com>
References: <1326418852-19378-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326418852-19378-1-git-send-email-jhbird.choi@samsung.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 10:40:52AM +0900, jhbird.choi@samsung.com wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Remove "wm8350->irq_base = pdata->irq_base" to avoid
> null pointer exception and wm8350->irq_base got from
> irq_alloc_descs().

Always send patches to the relevant maintainers - for the MFD subsystem
the maintainer is Samuel Ortiz.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/mfd/wm8350-irq.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
> index 8a1fafd..9fd01bf 100644
> --- a/drivers/mfd/wm8350-irq.c
> +++ b/drivers/mfd/wm8350-irq.c
> @@ -496,7 +496,6 @@ int wm8350_irq_init(struct wm8350 *wm8350, int irq,
>  
>  	mutex_init(&wm8350->irq_lock);
>  	wm8350->chip_irq = irq;
> -	wm8350->irq_base = pdata->irq_base;
>  
>  	if (pdata && pdata->irq_base > 0)
>  		irq_base = pdata->irq_base;
> -- 
> 1.7.1
> 
