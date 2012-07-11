Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2GKIU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:20:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56012 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2GKIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:20:24 -0400
Date: Wed, 11 Jul 2012 10:20:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120711082018.GB17713@gmail.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <201207101652.18401.arnd@arndb.de>
 <20120710203527.GA16986@gmail.com>
 <201207102119.38495.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207102119.38495.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> > Do you really think that all of the 32-bit ARM code should 
> > essentially be thrown away when going to 64-bit ARM, that 
> > patches can only touch arch/arm64/ + drivers/ or the 
> > highway?
> 
> Yes.

Straight answer ;-)

> If you're curious, please have a look at 
> arch/arm/mach-spear13xx/. this is the latest platform that we 
> have added. [...]

Very nice.

> [...] It's fully functional (except PCI, which I hope will be 
> added in drivers/pci/bus, which is another story), A 
> significant portion of that platform deals with SMP support, 
> which is being standardized for AArch64, so there will be only 
> one implementation. Another big portion is DMA-engine support, 
> which is moving out of arch/arm as soon as we have a proper DT 
> binding. Finally there are some boilerplate header files that 
> are going away too.
> 
> Once we're done with this, we will basically need zero code in 
> arch/*/ to support a new platform, and that is very easy to 
> share between two distinct arch/* directories ;-)

Ok, arch specific platform code going away completely is a valid 
solution - if you can pull that off for all new hardware then 
arch/arm64/ might actually work.

The life time of ARM hw is also a lot shorter than on x86. Plus, 
given that Apple and MS keeps Linux away from their hardware 
cryptographically we only have to deal with hw makers who 
specifically *want* Linux support. A lot of the maintenance pain 
on x86 comes from the fact that Linux support on a lot of PC 
hardware is incidental, from the hw maker's POV.

Ok, sounds like a valid plan. Just fix the name please :-)

Thanks,

	Ingo
