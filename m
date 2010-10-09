Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706Ab0JIXwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 19:52:34 -0400
Received: from kroah.org ([198.145.64.141]:54123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760670Ab0JIXwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 19:52:03 -0400
Date: Sat, 9 Oct 2010 16:52:11 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken
	on SGI UV
Message-ID: <20101009235211.GC15564@kroah.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com> <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com> <201010100138.18129.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010100138.18129.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 01:38:17AM +0200, Rafael J. Wysocki wrote:
> On Sunday, October 10, 2010, Linus Torvalds wrote:
> > On Sat, Oct 9, 2010 at 2:34 PM, Dave Airlie <airlied@gmail.com> wrote:
> > >
> > > Do we track people dong this at all? I wonder how many patches in
> > > linux-next have cc: stable in them but haven't been submitted to
> > > Linus,
> > 
> > The other side of that coin is to wonder how many patches get marked
> > as "stable" when they definitely shouldn't be.
> > 
> > I know that's a non-empty set. Too many developers think that the
> > thing they fix is so important that it needs to be backported. And it
> > doesn't help that Greg is sometimes over-eager to take things without
> > them being even in my tree long enough to get much testing.
> > 
> > Quite frankly, if somebody has something in "next" (and really meant
> > for the _next_ merge window, not the current one) that is marked for
> > stable, I think that shows uncommonly bad taste. And that, in turn,
> > means that the "stable" tag is also very debatable. It clearly cannot
> > be important enough to really be for stable if it's not even being
> > aggressively pushed into the current -rc.
> 
> Well, I know of at least one regression fix that is waiting in linux-next
> for the upcoming merge window and it most likely is tagged as -stable material.

Which one is it?

curious,

greg k-h
