Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1DBTIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 15:08:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:53196 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab1DBTIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 15:08:20 -0400
Date: Sat, 2 Apr 2011 21:08:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make clocksource name const
In-Reply-To: <20110402141134.GA23324@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1104022107520.5929@localhost6.localdomain6>
References: <20110219153450.GI29493@n2100.arm.linux.org.uk> <20110402141134.GA23324@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Apr 2011, Russell King - ARM Linux wrote:

> Has this patch been rejected?

No, I think it just got lost. Will pick it up.
 
> On Sat, Feb 19, 2011 at 03:34:50PM +0000, Russell King - ARM Linux wrote:
> > As nothing should be writing to the clocksource name string, make the
> > clocksource name pointer const.  Build-tested on ARM Versatile Express.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > ---
> >  include/linux/clocksource.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> > index c37b21a..94c1f38 100644
> > --- a/include/linux/clocksource.h
> > +++ b/include/linux/clocksource.h
> > @@ -161,7 +161,7 @@ struct clocksource {
> >  	/*
> >  	 * First part of structure is read mostly
> >  	 */
> > -	char *name;
> > +	const char *name;
> >  	struct list_head list;
> >  	int rating;
> >  	cycle_t (*read)(struct clocksource *cs);
> 
