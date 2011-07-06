Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1GFFjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:39:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37889 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab1GFFjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:39:02 -0400
Date: Tue, 5 Jul 2011 23:38:59 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] spi/tegra: Use engineering names in DT compatible
 property
Message-ID: <20110706053859.GD9978@ponder.secretlab.ca>
References: <1309897082-22695-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309897082-22695-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:18:02PM -0600, Stephen Warren wrote:
> Engineering names are more stable than marketing names. Hence, use them
> for Device Tree compatible properties instead.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Grant, this is against devicetree/arm, and also makes sense for
> devicetree/test.

Applied to spi/next, thanks.

g.

> 
>  .../devicetree/bindings/spi/spi_nvidia.txt         |    2 +-
>  drivers/spi/spi_tegra.c                            |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi_nvidia.txt b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
> index bde450b..6b9e518 100644
> --- a/Documentation/devicetree/bindings/spi/spi_nvidia.txt
> +++ b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
> @@ -1,5 +1,5 @@
>  NVIDIA Tegra 2 SPI device
>  
>  Required properties:
> -- compatible : should be "nvidia,tegra250-spi".
> +- compatible : should be "nvidia,tegra20-spi".
>  - gpios : should specify GPIOs used for chipselect.
> diff --git a/drivers/spi/spi_tegra.c b/drivers/spi/spi_tegra.c
> index 1e7de98..b0e3586 100644
> --- a/drivers/spi/spi_tegra.c
> +++ b/drivers/spi/spi_tegra.c
> @@ -598,7 +598,7 @@ MODULE_ALIAS("platform:spi_tegra");
>  
>  #ifdef CONFIG_OF
>  static struct of_device_id spi_tegra_of_match_table[] __devinitdata = {
> -	{ .compatible = "nvidia,tegra250-spi", },
> +	{ .compatible = "nvidia,tegra20-spi", },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(of, spi_tegra_of_match_table);
> -- 
> 1.7.0.4
> 
