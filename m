Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0E1Neu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:34:50 -0400
Received: from www.tglx.de ([62.245.132.106]:47453 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab0E1Nes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:34:48 -0400
Date: Fri, 28 May 2010 15:34:25 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: sha@pengutronix.de, Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>,
       Vladimir Zapolskiy <vzapolskiy@gmail.com>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Fabio Estevam <fabio.estevam@freescale.com>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mx35: add flexcan devices
Message-ID: <20100528133424.GA2001@bluebox.local>
References: <1275046938-8465-1-git-send-email-mkl@pengutronix.de>
 <1275046938-8465-5-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275046938-8465-5-git-send-email-mkl@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 01:42:18PM +0200, Marc Kleine-Budde wrote:
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  arch/arm/mach-mx3/devices.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-mx3/devices.h |    2 ++
>  2 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mx3/devices.c b/arch/arm/mach-mx3/devices.c
> index db7acd6..0e1e20b 100644
> --- a/arch/arm/mach-mx3/devices.c
> +++ b/arch/arm/mach-mx3/devices.c
> @@ -127,6 +127,46 @@ struct platform_device mxc_uart_device4 = {
>  };
>  #endif /* CONFIG_ARCH_MX31 */
>  
> +#ifdef CONFIG_ARCH_MX35
> +static struct resource mxc_can_1_resources[] = {
> +	{
> +		.start	= 0x53fe4000,
> +		.end	= 0x53fe7fff,
> +		.flags	= IORESOURCE_MEM,
> +	}, {
> +		.start	= 43,
> +		.end	= 43,
> +		.flags	= IORESOURCE_IRQ,
> +	}
> +};
> +
> +struct platform_device mxc_can_device0 = {
> +	.name = "flexcan",

Did you also post the flexcan driver itself somewhere? I've got such a device
on my desk right now, and would be willing to test that. I've made some tests
with Sascha's old version, but it's not really satisfying...

Thanks,
Hans
