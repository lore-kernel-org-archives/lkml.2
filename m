Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1FGXOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:14:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43529 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1FGXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:14:02 -0400
Date: Tue, 7 Jun 2011 17:14:00 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio-ep93xx: fix pr_fmt output
Message-ID: <20110607231400.GA5509@ponder.secretlab.ca>
References: <201106071352.02183.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106071352.02183.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 01:52:01PM -0700, H Hartley Sweeten wrote:
> With this driver now being moved from arch/arm/mach-ep93xx/gpio.c to
> drivers/gpio/gpio-ep93xx.c the prefix "ep93xx" is now redundant in the
> pr_* output. Using KBUILD_MODNAME is sufficient.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Applied, thanks.

g.

> 
> ---
> 
> diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
> index c33c9a8..3d427b9 100644
> --- a/drivers/gpio/gpio-ep93xx.c
> +++ b/drivers/gpio/gpio-ep93xx.c
> @@ -11,7 +11,7 @@
>   *  published by the Free Software Foundation.
>   */
>  
> -#define pr_fmt(fmt) "ep93xx " KBUILD_MODNAME ": " fmt
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/init.h>
>  #include <linux/module.h>
