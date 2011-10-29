Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab1J2LGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 07:06:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44141 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab1J2LGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 07:06:19 -0400
Date: Sat, 29 Oct 2011 13:06:13 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Jeff Garzik <jeff@garzik.org>,
        linux-kernel@vger.kernel.org, swarren@nvidia.com, olof@lixom.net,
        ben@decadent.org.uk, arnaud.patard@rtp-net.org, w.sang@pengutronix.de,
        bs14@csr.com
Subject: Re: [PATCH] ARM: mark empty gpio.h files empty
Message-ID: <20111029110613.GE20132@ponder.secretlab.ca>
References: <1319833142-4764-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319833142-4764-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 10:19:02PM +0200, Linus Walleij wrote:
> It is generally a better idea to make intentionally empty files
> contain the human-readable /* empty */ comment, also it makes
> the files play nice with "make distclean".
> 
> Reported-by: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.

> ---
>  arch/arm/mach-lpc32xx/include/mach/gpio.h |    1 +
>  arch/arm/mach-tegra/include/mach/gpio.h   |    1 +
>  arch/arm/mach-u300/include/mach/gpio.h    |    1 +
>  3 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-lpc32xx/include/mach/gpio.h b/arch/arm/mach-lpc32xx/include/mach/gpio.h
> index e69de29..40a8c17 100644
> --- a/arch/arm/mach-lpc32xx/include/mach/gpio.h
> +++ b/arch/arm/mach-lpc32xx/include/mach/gpio.h
> @@ -0,0 +1 @@
> +/* empty */
> diff --git a/arch/arm/mach-tegra/include/mach/gpio.h b/arch/arm/mach-tegra/include/mach/gpio.h
> index e69de29..40a8c17 100644
> --- a/arch/arm/mach-tegra/include/mach/gpio.h
> +++ b/arch/arm/mach-tegra/include/mach/gpio.h
> @@ -0,0 +1 @@
> +/* empty */
> diff --git a/arch/arm/mach-u300/include/mach/gpio.h b/arch/arm/mach-u300/include/mach/gpio.h
> index e69de29..40a8c17 100644
> --- a/arch/arm/mach-u300/include/mach/gpio.h
> +++ b/arch/arm/mach-u300/include/mach/gpio.h
> @@ -0,0 +1 @@
> +/* empty */
> -- 
> 1.7.3.2
> 
