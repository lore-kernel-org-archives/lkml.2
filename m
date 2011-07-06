Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1GFFjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:39:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48703 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab1GFFjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:39:44 -0400
Date: Tue, 5 Jul 2011 23:39:41 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: ben-linux@fluff.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] i2c: tegra: Use engineering names in DT compatible
 property
Message-ID: <20110706053941.GE9978@ponder.secretlab.ca>
References: <1309897306-22953-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309897306-22953-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:21:46PM -0600, Stephen Warren wrote:
> Engineering names are more stable than marketing names. Hence, use them
> for Device Tree compatible properties instead.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Grant, this is against devicetree/arm and also makes sense for
> devicetree/test.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Ben is the one to pick up this patch.

g.

> 
>  drivers/i2c/busses/i2c-tegra.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 8914bd1..99b1b6d 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -716,7 +716,7 @@ static int tegra_i2c_resume(struct platform_device *pdev)
>  #if defined(CONFIG_OF)
>  /* Match table for of_platform binding */
>  static const struct of_device_id tegra_i2c_of_match[] __devinitconst = {
> -	{ .compatible = "nvidia,tegra250-i2c", },
> +	{ .compatible = "nvidia,tegra20-i2c", },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
> -- 
> 1.7.0.4
> 
