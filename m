Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2ICNiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:38:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45552 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596Ab2ICNix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:38:53 -0400
Date: Mon, 3 Sep 2012 14:38:39 +0100
From: Will Deacon <will.deacon@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: ux500: Fix build error due to missing include of
 asm/pmu.h in cpu-db8500.c
Message-ID: <20120903133839.GC31542@mudshark.cambridge.arm.com>
References: <1346588747.7909.2.camel@phoenix>
 <CACRpkdYxYGa=C092rbTU5bo=YEu6wqiTUD7W4pLS_wNfmAe4Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYxYGa=C092rbTU5bo=YEu6wqiTUD7W4pLS_wNfmAe4Zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 11:47:51AM +0100, Linus Walleij wrote:
> On Sun, Sep 2, 2012 at 2:25 PM, Axel Lin <axel.lin@gmail.com> wrote:
> 
> > Include asm/pmu.h to fix below build error:
> >
> >   CC      arch/arm/mach-ux500/cpu-db8500.o
> > arch/arm/mach-ux500/cpu-db8500.c:118:8: error: variable 'db8500_pmu_platdata' has initializer but incomplete type
> > arch/arm/mach-ux500/cpu-db8500.c:119:2: error: unknown field 'handle_irq' specified in initializer
> > arch/arm/mach-ux500/cpu-db8500.c:119:2: warning: excess elements in struct initializer [enabled by default]
> > arch/arm/mach-ux500/cpu-db8500.c:119:2: warning: (near initialization for 'db8500_pmu_platdata') [enabled by default]
> > make[1]: *** [arch/arm/mach-ux500/cpu-db8500.o] Error 1
> > make: *** [arch/arm/mach-ux500] Error 2
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> That's on linux-next not on v3.6-rcN right?
> 
> I've applied it to my ux500 branch and will carry it unless Will Deacon
> express an interest in it, PMU is his territory...

I've already sent a pull for those patches, so please can you carry the
fixup? u8500 is the only platform using the arm_pmu_platdata at the moment
so it has to keep the include.

Cheers,

Will
