Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2FRWqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:46:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47165 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2FRWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:46:00 -0400
Date: Mon, 18 Jun 2012 15:45:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>
Subject: Re: linux-next: Tree for Jun 18 (kmsg problems)
Message-ID: <20120618224556.GA2750@kroah.com>
References: <20120618165336.48345227c6b64c314326ae57@canb.auug.org.au>
 <4FDF61A7.3050601@xenotime.net>
 <20120619080109.b28055c1b32fb81027a9562b@canb.auug.org.au>
 <20120618221535.GA13037@kroah.com>
 <20120619083720.996b2d743cff619a58e1de97@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619083720.996b2d743cff619a58e1de97@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 08:37:20AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 18 Jun 2012 15:15:35 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > > Caused by commit e2ae715d66bf ("kmsg - kmsg_dump() use iterator to
> > > receive log buffer content") from the driver-core.current tree.
> > 
> > I'm building my tree right now, and I can't seem to hit this.
> 
> You need CONFIG_PRINTK turned off ...

Ugh, no wonder I couldn't reproduce it, who runs systems like that
becides the CONFIG_TINY people?  :)

> > > This was reported a few days ago.  Why is it not fixed yet?
> > 
> > It was reported Friday evening, on a holiday weekend for some of us, we
> > are trying the best we can :)
> 
> Ah ha, another of those pesky holiday things :-)
> 
> > > Especially since it is in a branch that is supposedly "bug fixes"?
> > 
> > It fixes up a reported problem, and we had 3 people test it and said it
> > resolved the issue for them, no build problems reported.
> 
> My usual mantra is that if your patch is modifying code that clearly
> depends on a CONFIG option, you must test with that option both on and
> off. I see build problems in linux-next all the time where this has not
> been done.  :-(

Thanks, as this was a kmsg thing, I didn't catch that CONFIG_PRINTK was
involved, sorry about that.

I'll go queue up Kay's patch right now,

greg k-h
