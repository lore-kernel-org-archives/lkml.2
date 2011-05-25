Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab1EYH7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:59:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56466 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554Ab1EYH7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:59:10 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+G9qLIe1Hp5S1q8cBXLYiG
Date: Wed, 25 May 2011 10:59:02 +0300
From: Tony Lindgren <tony@atomide.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Message-ID: <20110525075902.GH30799@atomide.com>
References: <201105181047.17309.arnd@arndb.de>
 <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [110518 17:49]:
> Arnd,
> 
> On 18 May 2011 09:47, Arnd Bergmann <arnd@arndb.de> wrote:
> > This is the draft plan for maintaining the ARM subarchitectures in a common
> > tree, as a way to help coordinate the upstream merging of the
> > arch/arm/{plat,mach}-* changes into Linus' tree.
> 
> For clarification - the aim of this subarchitecture group is not only
> to coordinate the upstream merging but also take an active (primary)
> role in consolidating the existing code across various
> subarchitectures under arch/arm/.

It's good to see organized effort on consolidating the code.
And Linaro is probably the best place to organize this effort.

Naturally I assume that you guys won't be merging any platform
specific patches without proper acks from the platform maintainers:

Acked-by: Tony Lindgren <tony@atomide.com>

Arnd, do you want to do a practise run with pulling in the omap
code and merging to Linus for this merge window?

Regards,

Tony
