Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1IUPAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:00:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41707 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825Ab1IUPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:00:36 -0400
X-Sasl-enc: VopK1uHGVVDj9APUpv1rOKi/nBYOYSjala5kPB+0/7t0 1316617235
Date: Tue, 20 Sep 2011 16:45:15 -0700
From: Greg KH <greg@kroah.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/10] hwspinlock-next
Message-ID: <20110920234515.GA16276@kroah.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
 <CAK=Wgbam6u1bq8fG+oMUhxfWH1g3dU7q+VhPWFEZOLgFMV_3vQ@mail.gmail.com>
 <20110920231340.GT18894@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920231340.GT18894@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 04:13:40PM -0700, Tony Lindgren wrote:
> * Ohad Ben-Cohen <ohad@wizery.com> [110920 01:34]:
> > On Mon, Sep 12, 2011 at 7:46 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > 
> > I'm wondering how hwspinlock updates like this should go upstream.
> > 
> > The first hwspinlock batch was picked by Tony, because it involved a
> > bulk of OMAP changes.
> > 
> > Hwspinlock isn't OMAP-specific anymore though (we gained support for
> > STE's u8500) and the vast majority of changes are in drivers/. We're
> > still very much ARM-related, though this may change too at some point
> > (c6x has a similar "hardware semaphore" peripheral like the u8500
> > does).
> > 
> > Tony, if you're still willing to pick up these updates I'd be happy to
> > send you pull requests of course.
> 
> I'd prefer for Greg to take these as these are drivers.

What, am I the catch-all for drivers these days?

Oh, right, it looks like I am :)

> If he's not taking it at this point based on it being ARM only,
> I can take it then.

Please do, I don't even have the ability to build them here, as I don't
have an arm cross-compiler on this travel laptop.

greg k-h
