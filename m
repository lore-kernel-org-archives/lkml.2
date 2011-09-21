Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1IUQOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:14:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33847 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752436Ab1IUQOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:14:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/3DbsdRREtNJ8Uvb6fKRl1
Date: Wed, 21 Sep 2011 09:14:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/10] hwspinlock-next
Message-ID: <20110921161424.GG2937@atomide.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
 <CAK=Wgbam6u1bq8fG+oMUhxfWH1g3dU7q+VhPWFEZOLgFMV_3vQ@mail.gmail.com>
 <20110920231340.GT18894@atomide.com>
 <201109211612.33504.arnd@arndb.de>
 <20110921152812.GE2937@atomide.com>
 <CAK=WgbZ_1M-p+BtJnhw_uvaCnLaFRPA_tyv-rSGWMv2GQcB5Cw@mail.gmail.com>
 <CAK=WgbZw=q1HkU2U6iuzjSW==za5saFXmnf0yaYoHWkJfduZVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbZw=q1HkU2U6iuzjSW==za5saFXmnf0yaYoHWkJfduZVA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [110921 08:34]:
> On Wed, Sep 21, 2011 at 6:56 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > On Wed, Sep 21, 2011 at 6:28 PM, Tony Lindgren <tony@atomide.com> wrote:
> >> Ohad can you please try this first? Just please make sure your patches are
> >> first in next tree before sending in the pull request.
> >
> > Sure thing.
> >
> > Stephen, I'll send you the location of my tree in a few.
> 
> Just before I do, Tony can I please have your Ack for the mach-omap2
> part of this patch-set:
> 
>  arch/arm/mach-omap2/hwspinlock.c         |    8 +-

OK acked the related patch.

Tony
