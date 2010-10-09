Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab0JIXwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 19:52:09 -0400
Received: from kroah.org ([198.145.64.141]:54116 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760647Ab0JIXwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 19:52:02 -0400
Date: Sat, 9 Oct 2010 16:51:41 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken
	on SGI UV
Message-ID: <20101009235141.GB15564@kroah.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com> <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 04:24:59PM -0700, Linus Torvalds wrote:
> On Sat, Oct 9, 2010 at 2:34 PM, Dave Airlie <airlied@gmail.com> wrote:
> >
> > Do we track people dong this at all? I wonder how many patches in
> > linux-next have cc: stable in them but haven't been submitted to
> > Linus,
> 
> The other side of that coin is to wonder how many patches get marked
> as "stable" when they definitely shouldn't be.
> 
> I know that's a non-empty set. Too many developers think that the
> thing they fix is so important that it needs to be backported. And it
> doesn't help that Greg is sometimes over-eager to take things without
> them being even in my tree long enough to get much testing.

That's a tough thing to judge as I usually batch up stable
patches/releases every other week or so.  This can cause some patches to
be in your tree longer than others.

Should I just have a general "wait a week/release" type rule here before
adding them to a stable tree for most patches that aren't "obvious"?

thanks,

greg k-h
