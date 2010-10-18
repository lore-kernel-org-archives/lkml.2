Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab0JRUiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:38:05 -0400
Received: from fifo99.com ([67.223.236.141]:59182 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933316Ab0JRUiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:38:02 -0400
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@fifo99.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>, Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
In-Reply-To: <201010182219.25890.arnd@arndb.de>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
	 <alpine.LFD.2.00.1010181525000.2764@xanadu.home>
	 <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com>
	 <201010182219.25890.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 13:37:31 -0700
Message-ID: <1287434251.5588.23.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 22:19 +0200, Arnd Bergmann wrote:
> On Monday 18 October 2010 22:12:54 Daniel Walker wrote:
> > On Mon, 2010-10-18 at 15:29 -0400, Nicolas Pitre wrote:
> > 
> > > > Ok, well in that case why not accept this immediately after the merge
> > > > window? A point when everything is quiet, and most of the tree's are
> > > > empty?
> > > 
> > > RMK has his own merge window which closes about at the same time as 
> > > Linus' one opens.  We thought this was happening last week and therefore 
> > > this change was supposed to be the last one.
> > 
> > It seems like that could potentially make these kinds of problem worse,
> > since your merging things immediately before sending them to Linus. Like
> > right now we only have a fairly short amount of time to correct this
> > conflict. 
> 
> What Nicolas was talking about is the *end* of the merge window, not the
> start. This is how all sensible maintainer trees work: you get to
> merge stuff into the maintainer tree for a number of weeks (some start
> at -rc1, other start a bit later). When Linus tells people to get ready
> for the release, the subsystem goes into regression fix mode and when
> Linus opens his merge window, everything should be reasonably stable.

I think the term "merge window" is a little mis-leading here.. Your
describing development. To me the term merge window is indicating a
short period when you get changes in, not the whole -rc cycle.

> > > > Well how about I merge this change into my tree ?
> > > 
> > > If you ask RMK to merge your tree in his that would be much simpler to 
> > > add this change in a single pass afterwards.
> > 
> > I can do that , but would I still be able to merge stuff into my tree?
> > Seems like I could, Russell would just clean up the conflict and my tree
> > would just move forward like it has been already , and I would send the
> > whole thing to Linus.
> 
> When you know that Russell does not rebase his tree, you can pull his
> tree into yours whenever a change hits his tree that impacts you in
> a major way. You shouldn't do this too frequently, but it's a good way
> to resolve conflicts like this one.

If I did that all of Russell's changesets would get mixed with mine when
I send the pull request .. That would just create confusion .. It's OK
if Russell sends my commits to Linus, but I'm not going to send
Russell's commits.

Daniel

