Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab1E0BjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:39:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58931 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1E0BjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:39:13 -0400
Date: Thu, 26 May 2011 19:39:06 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [git pull] gpio changes for $NEXT_KERNEL
Message-ID: <20110527013906.GB5032@ponder.secretlab.ca>
References: <BANLkTi=S2quduA7-8Emqw7vE0J1eto6bgA@mail.gmail.com>
 <20110527111449.c3255407.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527111449.c3255407.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:14:49AM +1000, Stephen Rothwell wrote:
> Hi Grant,
> 
> On Thu, 26 May 2011 12:12:02 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
> >
> > Due to my own stupidity, this branch as /not/ been tested through
> > linux-next.  I put it in a branch that I negelcted to ask Stephen to
> > include.  :-(  I'm asking him to add it for tonight.  At the very
> > least, it has been build tested on various x86, powerpc, mips, sparc
> > and arm defconfigs.
> > 
> > You'll probably want to hold off on actually pulling this one, but I
> > wanted to give you a heads up that I have it still pending.  If you've
> > not picked it up, then I can resend the pull req tomorrow afternoon
> > after confirming it hasn't messed up anything in linux-next.
> > 
> > There's nothing earth shattering here.  Just a bunch of driver updates
> > and some faltering steps towards unifying a bunch of the mmio gpio
> > logic.
> > 
> > g.
> > 
> > The following changes since commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5:
> > 
> >   tmpfs: fix XATTR N overriding POSIX_ACL Y (2011-05-25 19:53:02 -0700)
> > 
> > are available in the git repository at:
> >   git://git.secretlab.ca/git/linux-2.6 gpio/next
> 
> I have added this tree even though it looks like Linus took it - just in
> case there is more stuff.
> 
> If you think it is unnecessary, let me know.

Thanks Stephen.  It's not unnecessary.  I'll be adding more stuff to
that branch for the next cycle.

g.

