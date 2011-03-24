Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab1CXDl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:41:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34359 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab1CXDl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:41:57 -0400
Date: Wed, 23 Mar 2011 21:41:51 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Miller <davem@davemloft.net>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of_mmc_spi: Need to include irq.h and of_irq.h
Message-ID: <20110324034151.GA27881@ponder.secretlab.ca>
References: <20110318.150023.27819221.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318.150023.27819221.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 03:00:23PM -0700, David Miller wrote:
> 
> Since these are the headers that provide irq_of_parse_and_map()
> and NO_IRQ.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Chris, let me know if you need me to take this via my tree.

g.

> 
> diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
> index 5530def..e2aecb7 100644
> --- a/drivers/mmc/host/of_mmc_spi.c
> +++ b/drivers/mmc/host/of_mmc_spi.c
> @@ -15,9 +15,11 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/slab.h>
> +#include <linux/irq.h>
>  #include <linux/gpio.h>
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
> +#include <linux/of_irq.h>
>  #include <linux/spi/spi.h>
>  #include <linux/spi/mmc_spi.h>
>  #include <linux/mmc/core.h>
