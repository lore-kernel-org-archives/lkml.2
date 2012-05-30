Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2E3HXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:23:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48285 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab2E3HXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:23:19 -0400
Date: Wed, 30 May 2012 09:23:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Chen <hi3766691@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
Message-ID: <20120530072313.GE2587@gmail.com>
References: <20120523113432.GA12142@gmail.com>
 <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
 <4FBD1AC8.7020602@zytor.com>
 <20120523174844.GA3373@gmail.com>
 <CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
 <4FBE5456.5020408@zytor.com>
 <CA+55aFyriUQCdEpa_YPBk-JvKAN26xC=MxWb3kO=xSkEou27dA@mail.gmail.com>
 <CANQmPXgxT3rvgGCOjztuGCTkgf4aa2-5a5q6K-8xPR1EcAsdgA@mail.gmail.com>
 <20120524170715.GB21355@gmail.com>
 <CANQmPXhSH3sGz670r7EmvhgZLX-fqGgEuO1N+6LVymC_p1SHyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANQmPXhSH3sGz670r7EmvhgZLX-fqGgEuO1N+6LVymC_p1SHyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chen <hi3766691@gmail.com> wrote:

> On Fri, May 25, 2012 at 1:07 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Interesting posts, first the "500K scheduler" nonsense now
> > printk nonsense?
> 
> printk nonsense?  You actually read my words wrong(LAUGH!)
> [I m going to quota my post]
>
> * Chen <hi3766691@gmail.com> wrote:
> > Everyone knows that this patch had been unstable. Also, too
> > much code are pushed into printk() with the patch
>
> I mean that too much code are brought with the patch.

The 'Everyone knows that this patch had been unstable' bit is 
the nonsense.

> 500K scheduler is true. 248K(Core.c[MODULAR]) + 
> 148K(fair.c[CFS]) + 47K(rt.c[RT]) = 443K.(Does not include the 
> other source files of scheduler.) It is really a *HUGE* CPU 
> scheduler.[But it doesn't bring much advantages to desktop!!]

You are quite confused. Here's the reply I gave you in the other 
thread:

Only binary code is counted in bytes, source code is counted in 
lines.

20 KLOC for a full-featured CPU scheduler that does everything 
from simple UP scheduling to thousands of CPUs NUMA scheduling, 
cgroups, real-time and more, is entirely reasonable.

As a comparison the VM is 80+ KLOCS, arch/x86/ is 260+ KLOCs, 
networking is 720+ KLOCS and the FS subsystem is over 1 million 
lines of code.

The scheduler is in fact one of the smaller subsystems.

Thanks,

	Ingo
