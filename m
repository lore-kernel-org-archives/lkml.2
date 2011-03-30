Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965390Ab1C3Vy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:54:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31248 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab1C3Vyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:54:54 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19jLyQakr3xftXcmfyb5Y+i
Date: Wed, 30 Mar 2011 14:54:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20110330215434.GI18334@atomide.com>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103302155270.22418@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103302155270.22418@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [110330 14:07]:
> 
> So one person will be not enough, that needs to be a whole team of
> experienced people in the very near future to deal with the massive
> tsunami of crap which is targeted at mainline. If we fail to set that
> up, then we run into a very ugly maintainability issue in no time.

One thing that will help here and distribute the load is to move
more things under drivers/ as then we have more maintainers looking
at the code.

Regards,

Tony
