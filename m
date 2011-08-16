Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1HPFgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:36:22 -0400
Received: from wdmail01.wdc.com ([129.253.55.43]:45641 "EHLO wdmail01.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab1HPFgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:36:21 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Aug 2011 01:36:21 EDT
X-IronPort-AV: E=Sophos;i="4.67,378,1309762800"; 
   d="scan'208";a="184268113"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Future of the -longterm kernel releases (i.e. how we pick them).
Date: Mon, 15 Aug 2011 22:26:54 -0700
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF2E3ED78@wdscexbe08.sc.wdc.com>
In-Reply-To: <20110815142142.GC11358@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Future of the -longterm kernel releases (i.e. how we pick them).
Thread-Index: AcxbVvn4FaBisyT5S2OUo1L0mynbOwAfCIug
References: <20110815041524.GA7578@kroah.com> <alpine.DEB.2.02.1108150007100.24266@asgard.lang.hm> <20110815142142.GC11358@kroah.com>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Aug 2011 05:26:54.0453 (UTC) FILETIME=[1C1A0250:01CC5BD5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Monday, August 15, 2011 7:22 AM
> To: david@lang.hm
> Cc: linux-kernel@vger.kernel.org; 
> torvalds@linux-foundation.org; akpm@linux-foundation.org; 
> alan@lxorguk.ukuu.org.uk; stable-review@kernel.org; stable@kernel.org
> Subject: Re: Future of the -longterm kernel releases (i.e. 
> how we pick them).
> 
> On Mon, Aug 15, 2011 at 12:21:59AM -0700, david@lang.hm wrote:
> > rather than having a hard schedule (the first kernel released after
> > July 1 each year for example I know this is not the exact proposal),
> > I think that it would be better to pick the -longterm kernel a few
> > months after it has been released (3.4 is looking very good, the
> > normal minor driver fixes in -stable, but no fundamental regressions
> > have been reported, it's the new -longerm kernel for example)
> > 
> > doing so doesn't give the predictability that some people will want
> > in knowing that their September release will always have a fresh new
> > -longerm kernel, but I think the result would be better -longterm
> > kernels. However, to get the information about how good the kernels
> > are, I think that the -stable timeframe would need to be extended to
> > give the kernels time to settle and gather reports. I would then
> > suggest scheduling that once a year you look at the last couple
> > -stable kernels and pick one of them rather than designating the new
> > -longterm kernel ahead of time.
> 
> Yes, that's a very good idea.  I've seen problems in the past when
> distros have made a time-based decision to pick a kernel version and
> then the problems that this can cause if it happens that a subsystem
> really had issues for that release.
> 
> So yes, I'll take a look at the bug reports and how things are working
> out to pick the next -longterm.  I'll also take into consideration any
> companies/major users that are going to be using that release as well,
> so it greatly behooves people to talk to me about their plans (hint,
> hint...)
> 
> > I hope my midnight rambling makes some sort of sense :-)
> 
> It did, thanks for the response.
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

I also appreciate the amount of work it takes to maintain a kernel; thanks.

For embedded systems, which often have multi- (not just two-) year
warranties, it sounds like we would then be maintaining the -longterm
ourselves.  The "easy" side of this is that embedded systems don't
(usually) have users trying to plug in the latest and greatest widget,
except on external busses, such as USB.  So back-porting drivers is
not generally a big deal.  Security patches, OTOH, are a real concern.
Other than net and drivers/net, which are exposed to non-local attacks,
are there other subsystems we should watch for security fixes?  There
have, for example, been a lot of security upgrades in /sys, but there's
also been a lot of restructing for new interfaces and "arch" models,
which would make back-porting those much more complicated.
