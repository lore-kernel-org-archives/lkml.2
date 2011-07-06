Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1GFFRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:17:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48506 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1GFFRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:17:52 -0400
Date: Tue, 5 Jul 2011 23:17:48 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, JorgeEduardoCandelariajedu@slimlogic.co.uk,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH] gpio: tps65910: add missing breaks in tps65910_gpio_init
Message-ID: <20110706051748.GA9978@ponder.secretlab.ca>
References: <1309918107.26847.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309918107.26847.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 10:08:27AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/gpio/gpio-tps65910.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Merged for v3.0, thanks.

g.

> 
> diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
> index 4171033..b9c1c29 100644
> --- a/drivers/gpio/gpio-tps65910.c
> +++ b/drivers/gpio/gpio-tps65910.c
> @@ -81,8 +81,10 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
>  	switch(tps65910_chip_id(tps65910)) {
>  	case TPS65910:
>  		tps65910->gpio.ngpio	= 6;
> +		break;
>  	case TPS65911:
>  		tps65910->gpio.ngpio	= 9;
> +		break;
>  	default:
>  		return;
>  	}
> -- 
> 1.7.4.1
> 
> 
> 
