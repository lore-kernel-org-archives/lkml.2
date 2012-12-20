Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2LTRgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:36:02 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:22475 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228Ab2LTRf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:35:56 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+mFvzumeLCuFwEe51gNzYj
Date: Thu, 20 Dec 2012 09:35:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Olof Johansson <olof@lixom.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        maxime.ripard@free-electrons.com
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
Message-ID: <20121220173548.GB4989@atomide.com>
References: <20121220163814.GA29557@quad.lixom.net>
 <CA+55aFxL47wxTyTzLdnoFV=trnrMAz=_7rhsQFjb+K_mvTCa9w@mail.gmail.com>
 <CAOesGMiZTF4gogCkU7eSaOydkX82wfWywkKBgCJo_-ZW0Ox4kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMiZTF4gogCkU7eSaOydkX82wfWywkKBgCJo_-ZW0Ox4kw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Olof Johansson <olof@lixom.net> [121220 09:30]:
> [proper reply-to-all this time]
> 
> On Thu, Dec 20, 2012 at 8:49 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Thu, Dec 20, 2012 at 8:38 AM, Olof Johansson <olof@lixom.net> wrote:
> >>
> >> One of the sunxi patches from the last pull request was misapplied (I
> >> realized what happened -- git am -s didn't apply cleanly so I had done it
> >> through regular patch, thus not catching the renames properly). Here's
> >> a fresh version of the pull request with a couple more OMAP and Samsung
> >> patches included.
> >
> > Argh!
> >
> > I pulled your earlier branch due to Tony's ack, and now you're
> > re-created that branch with new pulls (effectively rebasing it).
> >
> > Don't do things like this to me.
> 
> Yeah, sorry about that -- I wanted to replace the broken patch, and
> Tony's branch was based on a newer version of your tree so I brought
> everything forward as I had to rebase anyway.
> 
> I'll rebuild on top of what you've pulled, and send a fresh request of
> just the delta. Sorry about the race condition here.

Sorry for me adding to the confusion too.

Looks like Linus already applied "ARM: OMAP: Fix build breakage due
to missing include in i2c.c" that I had queued earlier.

Olof, I suggest you just merge my pull request up to the other commit
c16acf12 (ARM: OMAP2+: Fix compillation error in mach-omap2/timer.c).
Or just pick it whichever works better for you.

Regards,

Tony
