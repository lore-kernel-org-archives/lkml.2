Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1GJI6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 04:58:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37207 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab1GJI60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 04:58:26 -0400
Date: Sun, 10 Jul 2011 06:49:27 +0900
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Greg KH <gregkh@suse.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] tty/serial: tegra: Use engineering names in DT
 compatible property
Message-ID: <20110709214927.GF2805@ponder.secretlab.ca>
References: <1309896461-21976-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309896461-21976-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:07:41PM -0600, Stephen Warren wrote:
> Engineering names are more stable than marketing names. Hence, use them
> for Device Tree compatible properties instead.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Greg, This builds on patches Grant has (or has said he will have) in his
> devicetree/next branch, so I assume this change would be merged through
> the same route.
> 
> Grant, this patch is physically against devicetree/arm. The of-serial.txt
> change should also apply to devicetree/next as is, and you'd previously
> indicated that you'd queue the addition of the Tegra entry to of_serial.c
> in your devicetree/next branch, so this should apply on top of that once
> you have done so. Finally, this should go into devicetree/test too.

Hi Stephen.  I've just modified the original patch and put it into
devicetree/next.  Once I get back on the ground and have some internet
access, I'll push my tree out (this email will probably get out before
I get a chance to push out my tree).

g.

> 
>  .../devicetree/bindings/tty/serial/of-serial.txt   |    2 +-
>  drivers/tty/serial/of_serial.c                     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> index 337a7e5..b8b27b0 100644
> --- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> @@ -8,7 +8,7 @@ Required properties:
>  	- "ns16550"
>  	- "ns16750"
>  	- "ns16850"
> -	- "nvidia,tegra250-uart"
> +	- "nvidia,tegra20-uart"
>  	- "ibm,qpace-nwp-serial"
>  	- "serial" if the port type is unknown.
>  - reg : offset and length of the register set for the device.
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index e65f1e8..e58cece 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -181,7 +181,7 @@ static struct of_device_id __devinitdata of_platform_serial_table[] = {
>  	{ .compatible = "ns16550",  .data = (void *)PORT_16550, },
>  	{ .compatible = "ns16750",  .data = (void *)PORT_16750, },
>  	{ .compatible = "ns16850",  .data = (void *)PORT_16850, },
> -	{ .compatible = "nvidia,tegra250-uart", .data = (void *)PORT_TEGRA, },
> +	{ .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },
>  #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
>  	{ .compatible = "ibm,qpace-nwp-serial",
>  		.data = (void *)PORT_NWPSERIAL, },
> -- 
> 1.7.0.4
> 
