Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0DVFsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 01:48:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:59974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab0DVFsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 01:48:23 -0400
Date: Wed, 21 Apr 2010 22:49:02 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's the staging review and acceptance process?
Message-ID: <20100422054902.GA28037@suse.de>
References: <1271881967.1730.482.camel@Joe-Laptop.home> <20100422034532.GA25177@suse.de> <1271910357.1730.627.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271910357.1730.627.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 09:25:57PM -0700, Joe Perches wrote:
> On Wed, 2010-04-21 at 20:45 -0700, Greg KH wrote:
> > That caused the huge backlog staring at
> > me right now.
> 
> Which likely discouraged the new contributors who
> submitted stuff still in that backlog.

While a series of unfortunate events did happen to cause this, do you
have any evidence of this causing people to go away?  I have had a
number of queries about pending patches, all of which I quickly
responded to (travel being easy to write emails, just not do "real"
work).

> > I just went through 100 patches, and only 40 of them
> > were "valid" and able to be applied, so it is a high rejection rate
> > which requires a lot of attention to be paid to them.
> > 
> > > What is your current review/notify/accept/reject workflow?
> > 
> > Like it's always been:
> >   - patch comes in
> >   - I get around to reviewing it
> >   - if valid, I apply and you get an email
> >   - if invalid, I reject and say why in email
> 
> Unfortunately, your process has been opaque until you
> personally handle it.

Yes, like all subsystem maintainers, right?

> Does the driverdev list or any list always receive a copy
> or the feedback?

If it was copied, yes, it does.  I can't control who the original
submitters copy on their emails, but they usually do hit the driverdev
mailing list for the most part.

> > > Perhaps a patchwork queue for staging might help track these
> > > patches and with more feedback or reviewers, get them in
> > > shape to be applied.
> 
> > patchwork doesn't work well for my patch flow, but maybe that is because
> > I haven't spent enough time with it.  Right now I have all the patches,
> > it's just a matter of getting through them.
> 
> Maybe you should get some advice on using patchwork use
> from somebody like David Miller, who gets rather more
> patches for networking than staging gets.  The patchwork
> queue for networking always seems managed and it can use
> delegation, which your process doesn't seem capable of
> doing.  You're a voluntary bottleneck for staging, I
> think you either need to find personal cycles or find
> some other suckers willing to volunteer who'd make up
> more overall cycles.

Are you volunteering?

thanks,

greg k-h
