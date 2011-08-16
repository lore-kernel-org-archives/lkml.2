Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1HPC6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:58:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46141 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab1HPC6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:58:50 -0400
X-Sasl-enc: 6TZCjm8jtBFhUICdK6D0gpN35umsUWQVhnHY1C7rRNxt 1313463529
Date: Mon, 15 Aug 2011 19:56:25 -0700
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] Future of the -longterm kernel releases
 (i.e. how we pick them).
Message-ID: <20110816025625.GA6511@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <alpine.DEB.2.02.1108150007100.24266@asgard.lang.hm>
 <20110815142142.GC11358@kroah.com>
 <1313461616.2981.92.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313461616.2981.92.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 03:26:56AM +0100, Ben Hutchings wrote:
> On Mon, 2011-08-15 at 07:21 -0700, Greg KH wrote:
> > On Mon, Aug 15, 2011 at 12:21:59AM -0700, david@lang.hm wrote:
> > > rather than having a hard schedule (the first kernel released after
> > > July 1 each year for example I know this is not the exact proposal),
> > > I think that it would be better to pick the -longterm kernel a few
> > > months after it has been released (3.4 is looking very good, the
> > > normal minor driver fixes in -stable, but no fundamental regressions
> > > have been reported, it's the new -longerm kernel for example)
> > > 
> > > doing so doesn't give the predictability that some people will want
> > > in knowing that their September release will always have a fresh new
> > > -longerm kernel, but I think the result would be better -longterm
> > > kernels. However, to get the information about how good the kernels
> > > are, I think that the -stable timeframe would need to be extended to
> > > give the kernels time to settle and gather reports. I would then
> > > suggest scheduling that once a year you look at the last couple
> > > -stable kernels and pick one of them rather than designating the new
> > > -longterm kernel ahead of time.
> > 
> > Yes, that's a very good idea.  I've seen problems in the past when
> > distros have made a time-based decision to pick a kernel version and
> > then the problems that this can cause if it happens that a subsystem
> > really had issues for that release.
> > 
> > So yes, I'll take a look at the bug reports and how things are working
> > out to pick the next -longterm.  I'll also take into consideration any
> > companies/major users that are going to be using that release as well,
> > so it greatly behooves people to talk to me about their plans (hint,
> > hint...)
> [...]
> 
> This might be a good discussion to have at Kernel Summit, if enough
> distro people are going to be there.

I doubt the proper distro people will be at the Kernel Summit, sorry.
Perhaps at Plumbers or at LinuxCon Europe?

greg k-h
