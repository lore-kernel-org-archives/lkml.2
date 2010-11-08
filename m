Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0KHRjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:39:45 -0500
Received: from mail.perches.com ([173.55.12.10]:4628 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab0KHRjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:39:44 -0500
Subject: Re: [PATCH] arch/arm/plat-mxc/cpufreq.c: Fix line continuation
 defect
From: Joe Perches <joe@perches.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101108081808.GN16938@pengutronix.de>
References: <1289164215.29216.315.camel@Joe-Laptop>
	 <20101108081808.GN16938@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 09:39:43 -0800
Message-ID: <1289237983.29216.340.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 09:18 +0100, Uwe Kleine-König wrote:
> On Sun, Nov 07, 2010 at 01:10:15PM -0800, Joe Perches wrote:
> > diff --git a/arch/arm/plat-mxc/cpufreq.c b/arch/arm/plat-mxc/cpufreq.c
[]
> > -		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq \
> > -				with error code %d\n", __func__, ret);
> > +		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq with error code %d\n",
> > +		       __func__, ret);
> I'd prefer
> +		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq "
> +				"with error code %d\n", __func__, ret);
> (actually I'd consider
> +		pr_err("failed to register i.MXC CPUfreq (error: %d)\n", ret)
> even better, but this is out of scope for this patch, isn't it?)

Yes, it's out of scope.

I do have a perl & emacs script that converts
printk(KERN_<level> to pr_<level>, coalesces formats,
and wraps/aligns arguments.

It's around 2K lines of changes though for arch/arm.

Anyone want that all at once or by platform by platform?

