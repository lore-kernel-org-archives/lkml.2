Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1IUP2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:28:24 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:10976 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750861Ab1IUP2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:28:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18GrCrFCY3hDgYMhWwZd3X0
Date: Wed, 21 Sep 2011 08:28:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/10] hwspinlock-next
Message-ID: <20110921152812.GE2937@atomide.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
 <CAK=Wgbam6u1bq8fG+oMUhxfWH1g3dU7q+VhPWFEZOLgFMV_3vQ@mail.gmail.com>
 <20110920231340.GT18894@atomide.com>
 <201109211612.33504.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109211612.33504.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [110921 06:39]:
> On Wednesday 21 September 2011, Tony Lindgren wrote:
> > * Ohad Ben-Cohen <ohad@wizery.com> [110920 01:34]:
> > > On Mon, Sep 12, 2011 at 7:46 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > > 
> > > I'm wondering how hwspinlock updates like this should go upstream.
> > > 
> > > The first hwspinlock batch was picked by Tony, because it involved a
> > > bulk of OMAP changes.
> > > 
> > > Hwspinlock isn't OMAP-specific anymore though (we gained support for
> > > STE's u8500) and the vast majority of changes are in drivers/. We're
> > > still very much ARM-related, though this may change too at some point
> > > (c6x has a similar "hardware semaphore" peripheral like the u8500
> > > does).
> > > 
> > > Tony, if you're still willing to pick up these updates I'd be happy to
> > > send you pull requests of course.
> > 
> > I'd prefer for Greg to take these as these are drivers.
> > 
> > If he's not taking it at this point based on it being ARM only,
> > I can take it then.
> 
> Sorry for replying late, I had accidentally ignored the entire thread.
> 
> My feeling is that it would be best for Ohad to send these directly
> to Linus, since it's basically a standalone subsystem and he's listed
> as the maintainer (well, after this series at least).

Ohad can you please try this first? Just please make sure your patches are
first in next tree before sending in the pull request.
 
> I'm also fine with any of the other paths like
> 
> ohad->GregKH->torvalds

Greg does not prefer that as it's ARM only currently.

> ohad->arnd->torvalds
> ohad->tmlind->torvalds
> ohad->tmlind->arnd->torvalds

So as a backup plan any of these are also fine with me too.

Tony
