Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1C3WiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:38:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37412 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab1C3WiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:38:13 -0400
Date: Wed, 30 Mar 2011 15:38:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110330223807.GP2255@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103302155270.22418@localhost6.localdomain6>
 <20110330215434.GI18334@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330215434.GI18334@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 02:54:35PM -0700, Tony Lindgren wrote:
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

In many cases, the ARM SoC vendors will want their people producing the
code, so although moving things to drivers might be a good thing to do,
it won't really increase the number of people involved.  Plus the move
to the drivers subtree would be a problem for devices with tight ties
to the board or SoC.

There is work on pushing towards common code, but there is a lot of code
and this will take time and a lot of work.

							Thanx, Paul
