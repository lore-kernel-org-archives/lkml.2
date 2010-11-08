Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0KHJId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:08:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41983 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0KHJIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:08:32 -0500
Date: Mon, 8 Nov 2010 09:08:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Joe Perches <joe@perches.com>, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/plat-mxc/cpufreq.c: Fix line continuation
	defect
Message-ID: <20101108090803.GA13157@n2100.arm.linux.org.uk>
References: <1289164215.29216.315.camel@Joe-Laptop> <20101108081808.GN16938@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101108081808.GN16938@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 09:18:08AM +0100, Uwe Kleine-König wrote:
> Hi Joe,
> 
> On Sun, Nov 07, 2010 at 01:10:15PM -0800, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  arch/arm/plat-mxc/cpufreq.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/plat-mxc/cpufreq.c b/arch/arm/plat-mxc/cpufreq.c
> > index 039538e..9f358af 100644
> > --- a/arch/arm/plat-mxc/cpufreq.c
> > +++ b/arch/arm/plat-mxc/cpufreq.c
> > @@ -154,8 +154,8 @@ static int __init mxc_cpufreq_init(struct cpufreq_policy *policy)
> >  	ret = cpufreq_frequency_table_cpuinfo(policy, imx_freq_table);
> >  
> >  	if (ret < 0) {
> > -		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq \
> > -				with error code %d\n", __func__, ret);
> > +		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq with error code %d\n",
> > +		       __func__, ret);
> I'd prefer
> +		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq "
> +				"with error code %d\n", __func__, ret);

No - you don't wrap error messages.  It's the one exception to the 80
column rule.
