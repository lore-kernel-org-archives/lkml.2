Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1HOHWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:22:43 -0400
Received: from mail.lang.hm ([64.81.33.126]:44230 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab1HOHWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:22:41 -0400
Date: Mon, 15 Aug 2011 00:21:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        stable-review@kernel.org, stable@kernel.org
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick
 them).
In-Reply-To: <20110815041524.GA7578@kroah.com>
Message-ID: <alpine.DEB.2.02.1108150007100.24266@asgard.lang.hm>
References: <20110815041524.GA7578@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Aug 2011, Greg KH wrote:

> Proposal:
>
> Here's a first cut at a proposal, let me know if you like it, hate it,
> would work for you and your company, or not at all:
>
> - a new -longterm kernel is picked every year.
> - a -longterm kernel is maintained for 2 years and then dropped.
> - -stable kernels keep the same schedule that they have been (dropping
>  the last one after a new release happens.)  These releases are best
>  for products that require new hardware updates (desktop distros,
>  community distros, fast-moving embedded distros (like Yocto)).
> - the normal -stable rules apply to these -longterm kernels as described
>  in Documentation/stable_kernel_rules.txt
>
> This means that there are 2 -longterm kernels being maintained at the
> same time, and one -stable kernel.  I'm volunteering to do this work, as
> it's pretty much what I'm doing today anyway, and I have all of the
> scripts and workflow down.

I am one of the people who runs kernel.org kernels on my companies 
systems, and so I think I am well within the target of this proposal.

First off, let me say 'thank you' for your work here, now on to the ugly 
details :-)

There is definantly a need for a kernel that's maintained longer than the 
current -stable series is, there just isn't enough time to get comfortable 
with a new kernel before the -stable stops being maintained. What I end up 
doing is watching the vendor lists for alerts on things that relate to my 
configurations, and when I see them, work to jump to the latest kernel. 
this works, but not especially well.

a more regular -longterm kernel is appealing, but as I have been doing 
this since the kernel 1.3 days, I have seen a lot of kernels that ended up 
with just not being that good in subtle ways, and I'm not sure that just 
trying to backport smallish patches can really solve the problem.

rather than having a hard schedule (the first kernel released after July 1 
each year for example I know this is not the exact proposal), I think that 
it would be better to pick the -longterm kernel a few months after it has 
been released (3.4 is looking very good, the normal minor driver fixes in 
-stable, but no fundamental regressions have been reported, it's the new 
-longerm kernel for 
example)

doing so doesn't give the predictability that some people will want in 
knowing that their September release will always have a fresh new -longerm 
kernel, but I think the result would be better -longterm kernels. However, 
to get the information about how good the kernels are, I think that the 
-stable timeframe would need to be extended to give the kernels time to 
settle and gather reports. I would then suggest scheduling that once a 
year you look at the last couple -stable kernels and pick one of them 
rather than designating the new -longterm kernel ahead of time.

I hope my midnight rambling makes some sort of sense :-)

David Lang
