Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2KZJIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:08:35 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:47407 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2KZJIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:08:32 -0500
Date: Mon, 26 Nov 2012 10:08:14 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Philippe Reynes <tremyfr@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, eric.jarrige@armadeus.org,
        julien.boibessot@armadeus.com
Subject: Re: [PATCH 2/4] ds1374: add support of device tree
Message-ID: <20121126100814.1459e3d7@skate>
In-Reply-To: <1353874625-14754-3-git-send-email-tremyfr@yahoo.fr>
References: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
	<1353874625-14754-3-git-send-email-tremyfr@yahoo.fr>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Philippe Reynes,

On Sun, 25 Nov 2012 21:17:03 +0100, Philippe Reynes wrote:
> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
> ---
>  drivers/rtc/rtc-ds1374.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
> index 9663160..174c532 100644
> --- a/drivers/rtc/rtc-ds1374.c
> +++ b/drivers/rtc/rtc-ds1374.c
> @@ -49,6 +49,14 @@ static const struct i2c_device_id ds1374_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ds1374_id);
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id ds1374_of_match[] __devinitconst = {
> +	{ .compatible = "dallas,ds1374" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, ds1374_of_match);
> +#endif
> +

Don't we need a Device Tree binding documentation in
Documentation/devicetree/bindings/rtc/ ?

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
