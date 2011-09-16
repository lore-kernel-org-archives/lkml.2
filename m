Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1IPSkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:40:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab1IPSkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:40:05 -0400
Date: Fri, 16 Sep 2011 20:38:34 +0200
From: Greg KH <gregkh@suse.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Josh Boyer <jwboyer@redhat.com>, andi@firstfloor.org,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: stable patch queues and submission
Message-ID: <20110916183834.GA16415@suse.de>
References: <20110916181307.GW10700@zod.bos.redhat.com>
 <20110916182350.GA7315@suse.de>
 <20110916183516.GA4121@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916183516.GA4121@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 08:35:16PM +0200, Willy Tarreau wrote:
> On Fri, Sep 16, 2011 at 08:23:50PM +0200, Greg KH wrote:
> > > Hi All,
> > > 
> > > With kernel.org being down, the stable@kernel.org list is no longer
> > > working.  This leaves me wondering if we should send patches directly to
> > > the various stable tree maintainers with [stable] in the prefix and
> > > linux-kernel CC'd, or if the stable queues are even being maintained
> > > during the outage.
> > 
> > No, please do not, unless you need something "special", and even then,
> > please cc: lkml and the developers so it's not lost.
> > 
> > > Does anyone have a preference or suggestion on how to continue stable
> > > releases until the list comes back?  (I'm assuming 'wait' isn't really a
> > > best all around option.)
> > 
> > Wait and continue to add the marking to your patches, my scripts are
> > still running and pulling the patches out and they are going into the
> > stable queue just fine.  The queue just isn't public at the moment due
> > to kernel.org being out.
> 
> I was thinking about an alternative if that can help. If the mails are
> sent to our addresses followed by "+stable", they're easy to filter out
> to another mailbox (eg: "willy+stable@1wt.eu").
> 
> But there are a number of other reviewers on stable@k.o who provide a
> lot of value with their reviews, and not having them check the patches
> could easily lead to some nasty patches leaking into stable.

I agree, and the review of the final patches during the -rc period will
still happen.

I just don't want to see people start to drop using the "Cc: stable@..."
as part of their patches going to Linus if they somehow think they
should do something else.  This proceedure is still working just fine,
and when kernel.org comes back up, it will return to being an automated
process.

thanks,

greg k-h
