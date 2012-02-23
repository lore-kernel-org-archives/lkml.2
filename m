Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab2BWUDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:03:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34476 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2BWUC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:02:59 -0500
Date: Thu, 23 Feb 2012 12:02:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: raphael@buro.asia, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223200253.GA10840@kroah.com>
References: <4F4584EB.9060605@zytor.com>
 <CA+55aFxC6JwWsNcmkQ+DROXtWCzaq52DuX5aMJZfXMLoNCbsWg@mail.gmail.com>
 <20120223003706.GA3246@kroah.com>
 <6e9d38ffcb1a66f62a335450d4722809@buro.asia>
 <CA+55aFxTieMqacU9LN8Xmtb3Os8zkub1P+SKpqFtEBQ11STy7g@mail.gmail.com>
 <e709c3b5c5b2aa6e6a9d049f3af857e3@buro.asia>
 <20120223193620.GA16477@kroah.com>
 <CA+55aFwZqBdvB4HrW_mSzksimrWyRDhphkLbKxE9azmcb305Ow@mail.gmail.com>
 <20120223195007.GA5160@kroah.com>
 <20120223195511.GA8146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223195511.GA8146@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 11:55:11AM -0800, Greg Kroah-Hartman wrote:
> On Thu, Feb 23, 2012 at 11:50:07AM -0800, Greg Kroah-Hartman wrote:
> > On Thu, Feb 23, 2012 at 11:41:50AM -0800, Linus Torvalds wrote:
> > > On Thu, Feb 23, 2012 at 11:36 AM, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > 
> > > The insane safe_address games go away in the cleanup patch, so it
> > > really shouldn't be much of an issue.
> > > 
> > > In the end, save_address should just be
> > > 
> > >   #define safe_address (tsk->thread.has_fpu)
> > > 
> > > (and in fact the whole #define got removed entirely in mainline in
> > > commit 80ab6f1e8c98, which might be fodder for -stable too)
> > 
> > That's not where the merge caused problems, it was in
> > arch/x86/kernel/traps.c and arch/x86/kernel/process_64.c, either I'm
> > missing a patch that needs to be added to the series, or something else
> > is odd, let me dig...
> 
> No, something is messed up in my tree, let me try this again, this patch
> isn't the merge problem, something else is going on...

Ok, that was operator error on my side, it should all now be
straightened out and the patches applied just like was expected.

sorry for the noise.

greg k-h
