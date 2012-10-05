Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2JEPlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:41:08 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50668 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2JEPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:41:04 -0400
Date: Fri, 5 Oct 2012 17:41:01 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@amd64.org>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix bogus "callbacks suppressed" messages
Message-ID: <20121005154101.GA246@x4>
References: <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
 <20121005122741.GB8019@aftab.osrc.amd.com>
 <20121005125717.GB245@x4>
 <20121005142639.GA20065@kroah.com>
 <20121005152948.GC24764@aftab.osrc.amd.com>
 <20121005153706.GA13571@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005153706.GA13571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.10.05 at 08:37 -0700, Greg Kroah-Hartman wrote:
> On Fri, Oct 05, 2012 at 05:29:48PM +0200, Borislav Petkov wrote:
> > On Fri, Oct 05, 2012 at 07:26:39AM -0700, Greg Kroah-Hartman wrote:
> > > I don't have a problem with this patch, but I don't understand why
> > > it's now showing up. There haven't been any changes in the ratelimit.h
> > > area recently that I can see, so why is this change needed now? What
> > > is in the tty layer that is causing this, just the fact that it's
> > > actually being used now?
> > 
> > >From my quick semi-skilled git history browsing, I'd say it's
> > 5d4121c04b357 which added the WARN_RATELIMIT to tty_init_dev during the
> > current merge window.
> 
> So WARN_RATELIMIT was never working properly?  If so, how far back does
> it go in kernel releases that this should be fixed?

The only user until this merge window was net/core/filter.c. The
WARN_RATELIMIT is used there since v3.0.

-- 
Markus
