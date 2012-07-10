Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2GJVtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:49:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47254 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405Ab2GJVtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:49:01 -0400
Date: Tue, 10 Jul 2012 22:48:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710214836.GB4733@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <201207101652.18401.arnd@arndb.de>
 <20120710203527.GA16986@gmail.com>
 <201207102119.38495.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207102119.38495.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:19:38PM +0100, Arnd Bergmann wrote:
> On Tuesday 10 July 2012, Ingo Molnar wrote:
> > Do you really think that all of the 32-bit ARM code should 
> > essentially be thrown away when going to 64-bit ARM, that 
> > patches can only touch arch/arm64/ + drivers/ or the highway?
> 
> Yes.
> 
> If you're curious, please have a look at arch/arm/mach-spear13xx/.
> this is the latest platform that we have added. It's fully
> functional (except PCI, which I hope will be added in
> drivers/pci/bus, which is another story), A significant portion
> of that platform deals with SMP support, which is being standardized
> for AArch64, so there will be only one implementation. Another
> big portion is DMA-engine support, which is moving out of arch/arm
> as soon as we have a proper DT binding. Finally there are some
> boilerplate header files that are going away too.
> 
> Once we're done with this, we will basically need zero code
> in arch/*/ to support a new platform, and that is very easy
> to share between two distinct arch/* directories ;-)

OK, so Arnd's plan for 32-bit ARM SoCs are even better than what I've
envisaged ;)

-- 
Catalin
