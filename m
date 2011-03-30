Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1C3WkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:40:00 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:40568 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab1C3Wj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:39:58 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18rt1wMFZPD+auPfU6eIN0W
Date: Wed, 30 Mar 2011 15:39:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110330223946.GL18334@atomide.com>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <20110330214437.GH18334@atomide.com>
 <AANLkTikE5LXMkaSH4t4=DPvAOWXDh5Zyp0ESi=v2mra3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikE5LXMkaSH4t4=DPvAOWXDh5Zyp0ESi=v2mra3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [110330 15:18]:
> On Wed, Mar 30, 2011 at 2:44 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> But for ARM, I suspect even ACPI would actually be an improvement.
> Because on ARM, the crazy non-platform hw people already happened, and
> took over the insane asylum.  So having a complicated description
> language with an interpreter wouldn't be worse than what we already do
> there.
> 
> I'm only half kidding. I wouldn't wish for ACPI even on ARM. But..

Heh I think the device tree is saner here than ACPI :)
 
> > Anyways, let's plan on kicking out per-SoC and per-board data from
> > the kernel and get it from the bootloader via device tree in the
> > long run. Most of the data is already separate from the code, so
> > it should not be that hard to do, just takes some time.
> 
> This is basically my hope for the future. I just think that ARM people
> should be very very aggressive about it, because the longer it isn't
> done, the more crud there will be to convert.

At least now all that data is in one place in convertable format instead
of direct register tinkering of shared registers in each device driver
probe function..
 
> I bet it will be painful to do. But it will be even more painful to
> _not_ do it, and then five years from now realize that it should have
> been done ten years ago.

Something needs to be done for sure.

Tony
