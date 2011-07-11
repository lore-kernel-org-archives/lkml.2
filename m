Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1GKVJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:09:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51997 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1GKVJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:09:44 -0400
Date: Mon, 11 Jul 2011 23:09:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Cyril Hrubis <metan@ucw.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, rpurdie@rpsys.net,
        lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
        arminlitzel@web.de, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        omegamoon@gmail.com, utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: zaurus patches -- arm/pxa -- is Eric alive
Message-ID: <20110711210939.GA5682@elf.ucw.cz>
References: <20110711134150.GA15506@localhost.ucw.cz>
 <CALT56yM+fNs_2QorWK0=gr2um1H3vDX+HXPCi9bmKDdOdSvptA@mail.gmail.com>
 <20110711140303.GA32532@atrey.karlin.mff.cuni.cz>
 <CAMPhdO-UjxqyL47VsihX-fBD9VtAKkQqEQGj2u1YG0c90EHfqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMPhdO-UjxqyL47VsihX-fBD9VtAKkQqEQGj2u1YG0c90EHfqA@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Perhaps the most critical one is:
> >
> > [PATCH] MAX1111: Fix race condition causing NULL pointer exception
> >
> > http://ns1.yosemitephotos.net/lists/arm-kernel/msg125356.html

Yep, that one (or equivalent) is most critical.

> > Which fixes memory corruption that caused random oops.
> >
> > And then there is a bunch of fixes for charging and power management from
> > Pavel Machek:
> 
> Guys, I'm still alive, at least still breathing. Just too many mails
> and I was lost.

Good :-).

> > Disable CF during suspend
> >
> > https://lkml.org/lkml/2011/5/21/46
> 
> The fix is trivial, think I can take it. A better approach will be to have a
> generic CF power control function and invoke it in pcmcia driver when
> suspending.

Please take it. It is also regression from 2.6.15-or-so.

> > and spitz pm
> >
> > https://lkml.org/lkml/2011/5/21/72
> > https://lkml.org/lkml/2011/5/21/73
> > https://lkml.org/lkml/2011/5/21/76
> 
> Looks good to me, yet I need the last one Acked by power supply people.

Can you take the first two? They are trivial preparations... And I'll
get the ACKs...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
