Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab2JLNUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:20:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61886 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932973Ab2JLNUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:20:40 -0400
Date: Fri, 12 Oct 2012 14:20:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bryan.wu@canonical.com" <bryan.wu@canonical.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dave.martin@linaro.org" <dave.martin@linaro.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Leif Lindholm <Leif.Lindholm@arm.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "mmarek@suse.cz" <mmarek@suse.cz>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL 0/9] ARM architecture fixes for 3.7
Message-ID: <20121012132029.GC17399@mudshark.cambridge.arm.com>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
 <20121009160814.GH4625@n2100.arm.linux.org.uk>
 <201210091840.25176.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210091840.25176.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, Russell,

On Tue, Oct 09, 2012 at 07:40:24PM +0100, Arnd Bergmann wrote:
> On Tuesday 09 October 2012, Russell King - ARM Linux wrote:
> > 
> > On Tue, Oct 09, 2012 at 05:22:54PM +0200, Arnd Bergmann wrote:
> > > Here are some patches that belong into your domain, I hope you can
> > > just send the lot to Linus the next time you send other patches.
> > > 
> > > These bug fixes all address problems found with automated build testing.
> > > Some of them have been around for a long time, other bugs are
> > > regressions since the merge window.
> > 
> > Apart from the sliced off comment in one commit (which XEN people need
> > to confirm they're happy with the final version), I think these are
> > otherwise fine... I'll hold off pulling them until that can be fixed.
> 
> Fixed that now, and I also added the Acks that I got in the meantime,
> changed the dependency from Xen on (CPU_v7 && !CPU_V6), and edited the
> description for patch 6 as Dave suggested.
> 
> 	Arnd
> 
> 8<---
> The following changes since commit 0e51793e162ca432fc5f04178cf82b80a92c2659:
> 
>   Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm (2012-10-07 21:20:57 +0900)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-rmk
> 
> for you to fetch changes up to 8e7fc18b5eacc37b6e6fcf486ec4eafbfef91738:
> 
>   ARM: warnings in arch/arm/include/asm/uaccess.h (2012-10-09 20:29:07 +0200)

It would be good to see these for -rc1 if there's still time. I'm tired of
seeing patches to fix the export of the read_current_timer symbol!

Cheers,

Will
