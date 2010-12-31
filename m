Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0LaRCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:02:06 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:46905 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0LaRCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:02:04 -0500
Date: Fri, 31 Dec 2010 12:01:54 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Anca Emanuel <anca.emanuel@gmail.com>,
        Ubuntu kernel team mailing list 
	<kernel-team@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: is there a fix for ubuntu with intel GPU booting to blank
 screen?
In-Reply-To: <1293814089.6993.4.camel@maxim-laptop>
Message-ID: <alpine.DEB.2.00.1012311153190.3495@localhost6.localdomain6>
References: <alpine.DEB.2.00.1012270640240.3071@localhost6.localdomain6>  <AANLkTiktLCVQgGPCyt-fwVSkVmr8Ljr08UmvtkNG_zdp@mail.gmail.com>  <alpine.DEB.2.00.1012310836370.23681@localhost6.localdomain6> <1293814089.6993.4.camel@maxim-laptop>
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

... snip related to i915 blank screen issues ...

> Since you know how to compile kernel, and even have a close working
> version, you really should just bisect the bug.
>
> Bisection is a built-in in the git binary search that allows you to
> find the first commit that introduced the bug.
>
> For example, quick google gives,
> http://www.kernel.org/pub/software/scm/git-core/docs/v1.0.13/howto/isolate-bugs-with-bisect.txt

  oh, i know how to do bisection but, to be frank, i just don't have
the time.  i'm under a brutal deadline for some billable work and,
even if i had the time, i suspect that when i eventually tracked down
the commit, i probably wouldn't really appreciate what i was looking
at, anyway.

  i've done some searching on the issue and, among other pages, i've
come up with this one:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/683775

so i downloaded the kernel mentioned there and tested that, but no
luck.  mostly, i understand that there top men -- *top* *men* --
working on this :-) who know far more about the graphics subsystem
than i do so i'm just going to stay out of their way, but i'm willing
to test any proposed solutions if they come up.  my biggest worry is
that, given that we're already at -rc8, will this issue be fixed
before the next official release?

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
