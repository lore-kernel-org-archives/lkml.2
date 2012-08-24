Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2HXSKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:10:07 -0400
Received: from mail1-hoer.fullrate.dk ([89.150.129.84]:63337 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752819Ab2HXSJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:09:47 -0400
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
From: Martin Nybo Andersen <tweek@tweek.dk>
Date: Fri, 24 Aug 2012 20:09:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208242009.46270.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012 19:05:53 wbrana wrote:
> On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> > What I'd hate even more is rendering my old working hardware useless by
> > removing x86-32 support from the kernel. To reason the removal by saying
> > "Microsoft plans to do it" just makes me go bonkers...
> 
> Your old hardware will work fine with long term kernel.

That's right, but new hardware, that I wish to use with the old machines might 
not because of no backporting of new drivers. Same goes for new software 
utilising newer kernel features.

> > These legacy apps will most likely be compiled for x86-32 and not x32 (an
> > argument for not removing x86-32 support on a running x86-64 kernel).
> 
> Which legacy apps do you mean?

Those mentioned by Chris Friesen, whose arguments you apparently ignored.

Going back to your original arguments:
> x86-32
> - is deprecated since Linux supports X32.
No. X32 is merely yet another ABI supported by Linux.

> - will slow down adoption of X32
Perhaps. But that would rather be because of low benefits offered by x32 (not 
being able to run on legacy hardware is not a benefit (and not its 
intension)).

> - there won't be X32 versions of many software
You are allowed to compile most of the software running on Linux yourself. If 
you want a binary to use the x32 ABI, go compile. 

> - if new ABI was added, old one should be removed
No. If kernel.org runs out of diskspace, I'd rather sponsor some new disks.
And, x32 is an ABI for the x86-64 architecture, while x86-32 is an 
architecture in itself.

> - wastes time of developers who can spend their time supporting X32
> instead of x86-32 or support x86-64 only as 99% of users will be able
> to run x86-64 software if x86-32 will be dropped
No. If, for instance, an m68k maintainer/developer stops maintaining m68k 
support, nobody is telling him to continue his works on, say, sparc or 
whatever hyped architecture.

In other words: It costs exactly *nothing* for us to have x86-32 support. What 
is does cost, though, is the maintainers/developers spare time and goodwill. 
Something we all should appreciate.

> - wouldn't be dropped this year, but there should be plan when it will
> be dropped e.g. when Windows 9 will be released
No. That plan will come automagically when x86-32 is not used anymore and when 
somebody works on a patch to remove x86-32 support.

-- 
Cheers,
Martin
