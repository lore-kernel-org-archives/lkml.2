Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2HNVDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:03:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:33297 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab2HNVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:03:39 -0400
Date: Tue, 14 Aug 2012 23:03:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
In-Reply-To: <20120814192203.GY25632@google.com>
Message-ID: <alpine.LFD.2.02.1208142243500.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org> <20120813233520.GG25632@google.com> <alpine.LFD.2.02.1208142055260.32033@ionos> <20120814192203.GY25632@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Tejun Heo wrote:
> On Tue, Aug 14, 2012 at 09:16:16PM +0200, Thomas Gleixner wrote:
> > Why the hell are you trying to rush stuff which affects a well
> > maintained part of the kernel through your own tree w/o having the
> > courtesy of contacting the maintainer politely instead of sending an
> > ultimatum?
> >
> > You posted that series less than a week ago and there is no reason why
> > you need to push hard on inclusion into next after a few days.
> 
> So, it has been out for a while, and it's not the final inclusion into

Out for a while? You must be kidding.

The original post is from Wed. Aug 8th and your ultimatum mail is
dated Mon Aug 13th. That's a mere 3 working days.

> mainline.  The change to timer is fairly localized and you have enough
> opportunity to object before and after.  It's not like I'm gonna push
> it in against oppositions.

You seem to misunderstand what pushing into -next means. -next is not
a playground for random changes. It's an integration tree for stuff
which is supposed to show up in the next merge window. And stuff which
touches other maintainers trees needs to orginate from there or at
least be acked/reviewed-by those maintainers.

Why should -next have different rules to mainline?

> > If you really cared about my opinion you could have figured out that
> > I'm on vacation.
> 
> Ah... sorry but it's not like we date or anything.

Fortunately not. I wouldn't touch such an insensitive clod with a ten
foot pole.

Though other people whom I'm not dating either are sensitive enough to
send a polite mail after a few days:

<cite>
 Thomas, I figured out on IRC that you are on vacation. Would
 you be so kind to look at the patches I've posted 10 days ago? ....
</cite>

Do you see the subtle difference between a polite reminder after 10
days and an ultimatum after 5 days ?????

Thanks,

	tglx
