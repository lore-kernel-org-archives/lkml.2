Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1AALSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 06:18:15 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:39857 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1AALSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 06:18:14 -0500
Date: Sat, 1 Jan 2011 06:18:02 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Anca Emanuel <anca.emanuel@gmail.com>,
        Ubuntu kernel team mailing list 
	<kernel-team@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: is there a fix for ubuntu with intel GPU booting to blank
 screen?
In-Reply-To: <1293832014.27359.7.camel@maxim-laptop>
Message-ID: <alpine.DEB.2.00.1101010613320.5796@localhost6.localdomain6>
References: <alpine.DEB.2.00.1012270640240.3071@localhost6.localdomain6>  <AANLkTiktLCVQgGPCyt-fwVSkVmr8Ljr08UmvtkNG_zdp@mail.gmail.com>  <alpine.DEB.2.00.1012310836370.23681@localhost6.localdomain6>  <1293814089.6993.4.camel@maxim-laptop> 
 <alpine.DEB.2.00.1012311153190.3495@localhost6.localdomain6> <1293832014.27359.7.camel@maxim-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010, Maxim Levitsky wrote:

> On Fri, 2010-12-31 at 12:01 -0500, Robert P. J. Day wrote:
> > On Fri, 31 Dec 2010, Maxim Levitsky wrote:
> >
> > ... snip related to i915 blank screen issues ...
> >
> > > Since you know how to compile kernel, and even have a close working
> > > version, you really should just bisect the bug.
> > >
> > > Bisection is a built-in in the git binary search that allows you to
> > > find the first commit that introduced the bug.
> > >
> > > For example, quick google gives,
> > > http://www.kernel.org/pub/software/scm/git-core/docs/v1.0.13/howto/isolate-bugs-with-bisect.txt
> >
> >   oh, i know how to do bisection but, to be frank, i just don't have
> > the time.  i'm under a brutal deadline for some billable work and,
> > even if i had the time, i suspect that when i eventually tracked down
> > the commit, i probably wouldn't really appreciate what i was looking
> > at, anyway.

> You truly underestimate this. Having commit that broke things points
> perfectly at the issue. Then, developers can even just revert the
> offending commit until it is understood why it breaks stuff.

  one of the difficulties (if i'm reading this correctly) is that the
issue isn't even reliably reproducible.  a number of people who have
reported this claim that *sometimes* the system boots properly but
it's hit and miss, so it's not even clear you can bisect
deterministically.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
