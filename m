Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902Ab1GOCyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:54:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab1GOCx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:53:59 -0400
Date: Thu, 14 Jul 2011 20:53:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mcp23s08: remove unused work queue
Message-ID: <20110715025357.GY2927@ponder.secretlab.ca>
References: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
 <1310673568-30577-2-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310673568-30577-2-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 09:59:26PM +0200, Peter Korsgaard wrote:
> Never accessed anywhere.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

I've applied this, but I had to do it manually.  Please rebase the
remaining two patches on linux-next.

g.

> ---
>  drivers/gpio/mcp23s08.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
> index 40e0760..242a8a2 100644
> --- a/drivers/gpio/mcp23s08.c
> +++ b/drivers/gpio/mcp23s08.c
> @@ -4,7 +4,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/device.h>
> -#include <linux/workqueue.h>
>  #include <linux/mutex.h>
>  #include <linux/gpio.h>
>  #include <linux/spi/spi.h>
> @@ -60,8 +59,6 @@ struct mcp23s08 {
>  
>  	struct gpio_chip	chip;
>  
> -	struct work_struct	work;
> -
>  	const struct mcp23s08_ops	*ops;
>  };
>  
> -- 
> 1.7.5.4
> 
