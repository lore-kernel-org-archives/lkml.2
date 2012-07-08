Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2GHMCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 08:02:17 -0400
Received: from mx.treblig.org ([80.68.94.177]:53466 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2GHMCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 08:02:16 -0400
X-Greylist: delayed 2675 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2012 08:02:16 EDT
Date: Sun, 8 Jul 2012 12:17:36 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Jon Masters <jcm@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120708111736.GA11121@gallifrey>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
 <4FF93C99.80203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF93C99.80203@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.36.4-kvm-i386-20110819 (i686)
X-Uptime: 12:14:59 up 124 days, 21:48,  1 user,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jon Masters (jcm@redhat.com) wrote:
> On 07/07/2012 03:27 PM, Arnd Bergmann wrote:
> > On Saturday 07 July 2012, Olof Johansson wrote:
> > 
> >>> ARM introduced AArch64 as part of the ARMv8 architecture
> >>
> >> With the risk of bikeshedding here, but I find the name awkward. How
> >> about just naming the arch port arm64 instead? It's considerably more
> >> descriptive in the context of the kernel.  For reference, we didn't
> >> name ppc64, nor powerpc, after what the IBM/power.org marketing people
> >> were currently calling the architecture at the time either.
> > 
> > I agree the name sucks, and I'd much prefer to just call it arm64
> > as well. The main advantage of the aarch64 name is that it's the
> > same as the identifier in the elf triplet, and it makes sense to
> > keep the same name for all places where we need to identify the
> > architecture. This also includes the rpm and dpkg architecture names,
> > and the string returned by the uname syscall. If everything else
> > is aarch64, we should use that in the kernel directory too, but
> > if everyone calls it arm64 anyway, we should probably use that name
> > for as many things as possible.
> 
> FWIW I actually really like the aarch64 name (but you know that already
> :) ). I think it clearly spells out that this is not just a 64-bit
> extension to the existing 32-bit ARM Architecture, it is a new (inspired
> by ARM) architecture. Implementations will also run in AArch32 state
> (A32 and T32), but it's not like x86->x86_64.

It's one advantage is that it won't trigger the infinite number
of broken scripts out there that do something on arm*

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
