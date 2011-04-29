Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1D2WQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:16:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44834 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab1D2WQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:16:33 -0400
Date: Fri, 29 Apr 2011 23:15:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        KyongHo Cho <pullip.cho@samsung.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110429221554.GD14871@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <20110429075958.GV17290@n2100.arm.linux.org.uk> <20110429093209.1926c732@jbarnes-desktop> <201104292029.50680.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104292029.50680.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 08:29:50PM +0200, Arnd Bergmann wrote:
> On Friday 29 April 2011 18:32:09 Jesse Barnes wrote:
> > On Fri, 29 Apr 2011 08:59:58 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Fri, Apr 29, 2011 at 07:50:12AM +0200, Thomas Hellstrom wrote:
> > > > However, we should be able to construct a completely generic api around  
> > > > these operations, and for architectures that don't support them we need  
> > > > to determine
> > > >
> > > > a)  Whether we want to support them anyway (IIRC the problem with PPC is  
> > > > that the linear kernel map has huge tlb entries that are very  
> > > > inefficient to break up?)
> > > 
> > > That same issue applies to ARM too - you'd need to stop the entire
> > > machine, rewrite all processes page tables, flush tlbs, and only
> > > then restart.  Otherwise there's the possibility of ending up with
> > > conflicting types of TLB entries, and I'm not sure what the effect
> > > of having two matching TLB entries for the same address would be.
> > 
> > Right, I don't think anyone wants to see this sort of thing happen with
> > any frequency.  So either a large, uncached region can be set up a boot
> > time for allocations, or infrequent, large requests and conversions can
> > be made on demand, with memory being freed back to the main, coherent
> > pool under pressure.
> 
> I'd like to first have an official confirmation from the CPU designers
> if there is actually a problem with mapping a single page both cacheable
> and noncacheable.

Everytime this gets discussed, someone says that because they don't
believe what I say.  OMAP folk confirmed it last time around.

I'm getting tired of this.  I'm going to give up with answering any
further Linux questions until next week and I'll delete my entire
mailbox this weekend as I really can't be bothered to catch up with all
the crap that's happened over easter.  I'm really getting pissed off at
all the shite crap that's flying around at the moment that I'm really
starting to not care one ounce about Linux, either on ARM or on this
utterly shite and broken x86 hardware.

Let ARM rot in mainline.  I really don't care anymore.
