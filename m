Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1GOUDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 16:03:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53767 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1GOUDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 16:03:23 -0400
Date: Fri, 15 Jul 2011 14:03:20 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] gpio: wm831x: add a missing break in wm831x_gpio_dbg_show
Message-ID: <20110715200320.GI2833@ponder.secretlab.ca>
References: <1310283907.2774.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310283907.2774.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 03:45:07PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-wm831x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-wm831x.c b/drivers/gpio/gpio-wm831x.c
> index 31a9ed7..deb949e 100644
> --- a/drivers/gpio/gpio-wm831x.c
> +++ b/drivers/gpio/gpio-wm831x.c
> @@ -180,6 +180,7 @@ static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  			break;
>  		case WM831X_GPIO_PULL_UP:
>  			pull = "pullup";
> +			break;
>  		default:
>  			pull = "INVALID PULL";
>  			break;
> -- 
> 1.7.4.1
> 
> 
> 
