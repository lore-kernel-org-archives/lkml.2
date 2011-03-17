Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab1CQBvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 21:51:46 -0400
Received: from kroah.org ([198.145.64.141]:38445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab1CQBvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 21:51:42 -0400
Date: Wed, 16 Mar 2011 18:51:26 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [GIT PATCH] STAGING patches for .39
Message-ID: <20110317015126.GA31754@kroah.com>
References: <20110316210300.GA3311@kroah.com>
 <AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
 <20110317002818.GA19812@kroah.com>
 <AANLkTikEEDDFxZQtvV46JJRU1NAtiXh_N4onJ1jwKHaF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikEEDDFxZQtvV46JJRU1NAtiXh_N4onJ1jwKHaF@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 05:32:00PM -0700, Linus Torvalds wrote:
> On Wed, Mar 16, 2011 at 5:28 PM, Greg KH <greg@kroah.com> wrote:
> >>
> >> Aren't those things supposed to at least compile? What's going on?
> >
> > The gma500 driver will not build until you pull the drm tree into yours
> > as that is an api dependancy it needs.  I didn't think you build staging
> > drivers, so I didn't think I needed to call this one out.  I was wrong :)
> 
> I don't try to compile the staging tree all the time, but I do tend to
> try to check it every once in a while. So yes, let me know if there
> are dependencies.
> 
> > As for the others, I don't know of any build problems, what one did you
> > have a problem with?
> 
> The one with inifinite errors was vt6655.

Wierd, it builds for me in my branch that you pulled from.

I just tested it with my 'test merge' from earlier today to verify that
there were no merge issues, which was with your tree as of commit
0bbf211975addc2963b63a41a2eac99928365996 "Merge branch 'for-linus' of
git://android.git.kernel.org/kernel/tegra" and it builds there as well.

> It may be due to network layer changes. I had some other drivers with
> conflicts. Maybe this one didn't have content conflicts, but ended up
> having conflicts due to changed semantics etc.

Ah, perhaps, I don't know what changed with wireless recently, maybe
something broke them from that tree.  If so, I normally fix them up
right after -rc1 happens and will do so here as well, or earlier if you
push this merge out so I can see the problems.

thanks,

greg k-h
