Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0DNFOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:14:33 -0400
Received: from kroah.org ([198.145.64.141]:41943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab0DNFOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:14:22 -0400
Date: Tue, 13 Apr 2010 22:13:55 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>
Subject: Re: [PATCH] staging/dt3155: fix build error caused by
	{write|read}l change
Message-ID: <20100414051355.GC17429@kroah.com>
References: <201003031124.06345.hartleys@visionengravers.com> <20100408191123.GB31571@kroah.com> <0D753D10438DA54287A00B0270842697636D3679E8@AUSP01VMBX24.collaborationhost.net> <20100408204613.GA25396@kroah.com> <0D753D10438DA54287A00B0270842697636D5B7876@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636D5B7876@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 07:50:51PM -0500, H Hartley Sweeten wrote:
> On Thursday, April 08, 2010 1:46 PM, Greg KH wrote:
> > On Thu, Apr 08, 2010 at 03:38:06PM -0500, H Hartley Sweeten wrote:
> >> On Thursday, April 08, 2010 12:11 PM, Greg KH wrote:
> >>> On Wed, Mar 03, 2010 at 11:24:06AM -0700, H Hartley Sweeten wrote:
> >>>> This fixes a build error caused by replacing {Write | Read}MReg with 
> >>>> {write | read}l.
> >>>
> >>> Ick, can you merge this with your other patch so we don't have build
> >>> errors?  I just hit this and I had to drop all of your patches.
> >> 
> >> I was expecting you to NAK all of them anyway after I saw all the code 
> >> cleanup patches coming in on LKML.
> >> 
> >>> Can you respin all of them please?
> >> 
> >> Not a problem.  Are you planning on merging any of the dt3155 cleanup
> >> patches?  If so I will wait until they show up.
> >
> > I took some, you should have gotten the responses now.
> 
> Hello Greg,
> 
> Do you know off hand what (if any) of the dt3155 patches you took and when
> they might show up in linux-next?  The last commits in next-20100413 are:
> 
> commit 5a0e3ad6af8660be21ca98a971cd00f331318c05
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Mar 24 17:04:11 2010 +0900
> 
>     include cleanup: Update gfp.h and slab.h includes to prepare for breaking implicit slab.h inclusion from p
> 
> commit 3a8954e8f22cf31791d8c524c2839433e39f9368
> Author: H Hartley Sweeten <hartleys@visionengravers.com>
> Date:   Fri Feb 26 17:58:07 2010 -0700
> 
>     staging: dt3155: revert u_long to u64 usage


Hm, I need to tell Stephen to pull the proper tree for my staging-next
stuff, I am playing around with just using git for it.  Give me some
time, I'm in a conference all this week...

thanks,

greg k-h
