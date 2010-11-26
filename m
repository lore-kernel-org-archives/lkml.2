Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0KZKks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:40:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:6237 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0KZKkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:40:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,260,1288594800"; 
   d="scan'208";a="353495807"
Date: Fri, 26 Nov 2010 11:40:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd/mc13xxx: don't open-code mc13xxx_unlock
Message-ID: <20101126104043.GE5520@sortiz-mobl>
References: <1289490470-14195-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289490470-14195-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, Nov 11, 2010 at 04:47:50PM +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Looks good, patch applied.

Cheers,
Samuel.


> ---
>  drivers/mfd/mc13xxx-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index a2ac2ed..b9fcaf0 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -749,7 +749,7 @@ static int mc13xxx_probe(struct spi_device *spi)
>  	if (ret) {
>  err_mask:
>  err_revision:
> -		mutex_unlock(&mc13xxx->lock);
> +		mc13xxx_unlock(mc13xxx);
>  		dev_set_drvdata(&spi->dev, NULL);
>  		kfree(mc13xxx);
>  		return ret;
> -- 
> 1.7.2.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
