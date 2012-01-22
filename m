Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2AVTbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:31:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37263 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2AVTbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:31:25 -0500
Date: Sun, 22 Jan 2012 12:31:24 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Roland Stigge <stigge@antcom.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Correct bad gpio naming
Message-ID: <20120122193124.GX4223@ponder.secretlab.ca>
References: <4F1C4E25.6070801@antcom.de>
MIME-Version: 1.0
In-Reply-To: <4F1C4E25.6070801@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 22, 2012 at 06:57:57PM +0100, Roland Stigge wrote:
> One of the GPIO names in drivers/gpio/gpio-lpc32xx.c
> was bad. Renaming gpi000 -> gpio00
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied.  Careful though, this patch was corrupt (missing carriage
return before 'static' and had to be applied by hand.

g.

> 
> diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
> index 5b69480..ddfacc5 100644
> --- a/drivers/gpio/gpio-lpc32xx.c
> +++ b/drivers/gpio/gpio-lpc32xx.c
> @@ -96,7 +96,7 @@ static const char *gpio_p2_names[LPC32XX_GPIO_P2_MAX] = {
>  };
>   static const char *gpio_p3_names[LPC32XX_GPIO_P3_MAX] = {
> -	"gpi000", "gpio01", "gpio02", "gpio03",
> +	"gpio00", "gpio01", "gpio02", "gpio03",
>  	"gpio04", "gpio05"
>  };
> 
