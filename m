Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1G1WTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:19:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42048 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1G1WTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:19:39 -0400
Date: Thu, 28 Jul 2011 16:19:36 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, BIBEK BASU <bibek.basu@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH RESEND] gpio: ab8500: fix MODULE_ALIAS for ab8500
Message-ID: <20110728221936.GD4674@ponder.secretlab.ca>
References: <1311862609.2419.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311862609.2419.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 10:16:49PM +0800, Axel Lin wrote:
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
> with "platform:"), the platform modalias is prefixed with "platform:".
> 
> This patch changes the MODULE_ALIAS to "platform:ab8500-gpio".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-ab8500.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
> index ed795e6..050c05d 100644
> --- a/drivers/gpio/gpio-ab8500.c
> +++ b/drivers/gpio/gpio-ab8500.c
> @@ -516,5 +516,5 @@ module_exit(ab8500_gpio_exit);
>  
>  MODULE_AUTHOR("BIBEK BASU <bibek.basu@stericsson.com>");
>  MODULE_DESCRIPTION("Driver allows to use AB8500 unused pins to be used as GPIO");
> -MODULE_ALIAS("AB8500 GPIO driver");
> +MODULE_ALIAS("platform:ab8500-gpio");
>  MODULE_LICENSE("GPL v2");
> -- 
> 1.7.4.1
> 
> 
> 
