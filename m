Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683Ab0JIXwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 19:52:04 -0400
Received: from kroah.org ([198.145.64.141]:54111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab0JIXwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 19:52:01 -0400
Date: Sat, 9 Oct 2010 16:50:02 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken
	on SGI UV
Message-ID: <20101009235002.GA15564@kroah.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com> <20101010103810.497bb0e6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010103810.497bb0e6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 10:38:10AM +1100, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Sun, 10 Oct 2010 07:34:58 +1000 Dave Airlie <airlied@gmail.com> wrote:
> >
> > On Sun, Oct 10, 2010 at 4:39 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > On Sat, Oct 9, 2010 at 11:06 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > >>
> > >> It is too late for put in 2.6.36. Linus already had -rc7, and assume he will have final .36 this week.
> > >
> > > Anything that is worth tagging for stable is worth fixing before the
> > > final release (probably Wednesday).
> > 
> > Do we track people dong this at all? I wonder how many patches in
> > linux-next have cc: stable in them but haven't been submitted to
> > Linus,
> 
> Good idea.  The "stable" branch of linux-next is just where in Linus'
> tree that's day's linux-next was based.
> 
> # Friday's linux-next:
> $ git log --pretty=oneline -i --grep="cc:[ 	]*stable" stable.. | wc -l
> 71
> # origin/master is Linus' current tree
> $ git fetch origin
> $ git log --pretty=oneline -i --grep="cc:[ 	]*stable" origin/master.. | wc -l
> 70
> # so at least one went in over the weekend

Wow, that's a lot.

> Some of these will be false positives because commits get rebased before
> being sent to Linus (quilt trees especially).

Yes, but still, your list looks correct.

New device ids are something trivial which I mark for stable, but
usually hold off on submitting this late in the release cycle as it just
takes up time for everyone involved and they aren't a big deal.

Others in my tree are stuff that are "nice to have" but not essencial
for .37 at all for this point in time.

Then there's the wireless tree, which always loves to tag stuff and then
provide backports, but they want the stuff tested in Linus's tree first,
which is fine, so it waits for the next release.

thanks for the list,

greg k-h
