Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab1C3WZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:25:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:48681 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1C3WZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:25:21 -0400
Date: Thu, 31 Mar 2011 00:25:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Lindgren <tony@atomide.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <20110330215434.GI18334@atomide.com>
Message-ID: <alpine.LFD.2.00.1103310018540.22418@localhost6.localdomain6>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103302155270.22418@localhost6.localdomain6> <20110330215434.GI18334@atomide.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Tony Lindgren wrote:

> * Thomas Gleixner <tglx@linutronix.de> [110330 14:07]:
> > 
> > So one person will be not enough, that needs to be a whole team of
> > experienced people in the very near future to deal with the massive
> > tsunami of crap which is targeted at mainline. If we fail to set that
> > up, then we run into a very ugly maintainability issue in no time.
> 
> One thing that will help here and distribute the load is to move
> more things under drivers/ as then we have more maintainers looking
> at the code.

Guess what's that going to solve? Nothing, nada.

Really, you move the problem to people who are not prepared to deal
with the wave either. So what's the gain?

FYI, lots of the wreckage I observed regarding irq stuff was in
drivers/*

My statement stays the same. In whatever playground you try to shift
that problem in it's not going to scale the way it is right now,

Thanks,

	tglx
