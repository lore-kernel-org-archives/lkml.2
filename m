Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1C3WsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:48:06 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:43889 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab1C3WsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:48:03 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX199Mq7yH2hevJSbXoe1q+/K
Date: Wed, 30 Mar 2011 15:47:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110330224752.GN18334@atomide.com>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103302155270.22418@localhost6.localdomain6>
 <20110330215434.GI18334@atomide.com>
 <20110330223807.GP2255@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330223807.GP2255@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney <paulmck@linux.vnet.ibm.com> [110330 15:35]:
> On Wed, Mar 30, 2011 at 02:54:35PM -0700, Tony Lindgren wrote:
> > * Thomas Gleixner <tglx@linutronix.de> [110330 14:07]:
> > > 
> > > So one person will be not enough, that needs to be a whole team of
> > > experienced people in the very near future to deal with the massive
> > > tsunami of crap which is targeted at mainline. If we fail to set that
> > > up, then we run into a very ugly maintainability issue in no time.
> > 
> > One thing that will help here and distribute the load is to move
> > more things under drivers/ as then we have more maintainers looking
> > at the code.
> 
> In many cases, the ARM SoC vendors will want their people producing the
> code, so although moving things to drivers might be a good thing to do,
> it won't really increase the number of people involved.  Plus the move
> to the drivers subtree would be a problem for devices with tight ties
> to the board or SoC.
> 
> There is work on pushing towards common code, but there is a lot of code
> and this will take time and a lot of work.

I agree on the common code part, then even drivers with tight
ties to board or SoC become just generic drivers that are easy
to review.

Tony
