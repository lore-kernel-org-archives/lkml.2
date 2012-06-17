Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2FQKlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 06:41:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:45567 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab2FQKlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 06:41:03 -0400
Date: Sun, 17 Jun 2012 12:40:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: Greg KH <greg@kroah.com>, ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
In-Reply-To: <20120616072906.7469ec24@tpl.lwn.net>
Message-ID: <alpine.LFD.2.02.1206171204540.3086@ionos>
References: <alpine.LFD.2.02.1206152313310.3086@ionos> <20120615233413.GB8894@kroah.com> <alpine.LFD.2.02.1206161103320.3086@ionos> <20120616072906.7469ec24@tpl.lwn.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2012, Jonathan Corbet wrote:
> On Sat, 16 Jun 2012 12:50:05 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > A good start would be if you could convert your kernel statistics into
> > accounting the consolidation effects of contributions instead of
> > fostering the idiocy that corporates have started to measure themself
> > and the performance of their employees (I'm not kidding, it's the sad
> > reality) with line and commit count statistics.
> 
> I would dearly love to come up with a way to measure "real work" in
> some fashion; I've just not, yet, figured out how to do that.  I do
> fear that the simple numbers we're able to generate end up creating the
> wrong kinds of incentives.
> 
> Any thoughts on how to measure "consolidation effects"?  I toss out
> numbers on code removal sometimes, but that turns out to not be a whole
> lot more useful than anything else on its own.

I don't think there is an automated way.

How about not publishing the stats at all and just mention anything
related to them when something exceptional happens? E.g. out the the
blue 90% of the patches were submitted by hobbyists.

If you look at the stats of the last years, there is nothing really
interesting happening. We already know who employs the most kernel
developers and who of them is doing most of the work.

If companies really want to measure their "importance" or the
"performance" of their employees they can create their own stats and
abuse them for whatever they want.

Thanks,

	tglx
