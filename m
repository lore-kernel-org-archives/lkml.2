Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab1LGUZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:25:51 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32081 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755955Ab1LGUZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:25:50 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+8SM5qc766YdccOJB+TeJY
Date: Wed, 7 Dec 2011 12:25:47 -0800
From: Tony Lindgren <tony@atomide.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] rx51: add bq27200 i2c board info
Message-ID: <20111207202546.GJ31337@atomide.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <1680176.R2HCxgKt4B@pali-elitebook>
 <20111125230321.GA12373@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111125230321.GA12373@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anton Vorontsov <cbouatmailru@gmail.com> [111125 14:28]:
> Cc'ing Tony Lindgren.
> 
> Tony, OK to pass this via battery git tree?

Sorry for the delay, yes that's fine with me:

Acked-by: Tony Lindgren <tony@atomide.com>
 
> p.s. Though, not sure if we really should bother w/ these #ifs.

Up to you, looks like they could be left out.
 
> On Fri, Nov 25, 2011 at 11:53:06PM +0100, Pali Rohár wrote:
> > I forgot to send patch which enable bq27x00_battery driver on Nokia N900 RX51. Here is:
> > 
> > >From c06d00aa9d394ab5b65bbd5361c6da8424afbfe5 Mon Sep 17 00:00:00 2001
> > From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
> > Date: Fri, 25 Nov 2011 23:42:54 +0100
> > Subject: [PATCH] rx51: add bq27200 i2c board info
> > 
> > ---
> >  arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > index 5a886cd..23c626e 100644
> > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > @@ -940,6 +940,11 @@ static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_2[] = {
> >  		.platform_data  = &rx51_lp5523_platform_data,
> >  	},
> >  #endif
> > +#if defined(CONFIG_BATTERY_BQ27X00_I2C) || defined(CONFIG_BATTERY_BQ27X00_I2C_MODULE)
> > +	{
> > +		I2C_BOARD_INFO("bq27200", 0x55),
> > +	},
> > +#endif
> >  	{
> >  		I2C_BOARD_INFO("tpa6130a2", 0x60),
> >  		.platform_data = &rx51_tpa6130a2_data,
> 
> -- 
> Anton Vorontsov
> Email: cbouatmailru@gmail.com
