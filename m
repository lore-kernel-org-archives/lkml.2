Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0FDExl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:53:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57725 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0FDExj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:53:39 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18skNtZoISabDmBpDg4LZrZ
Date: Fri, 4 Jun 2010 07:53:02 +0300
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100604045300.GC6499@atomide.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603164623.GM30622@atomide.com>
 <20100603181303.GB25779@flint.arm.linux.org.uk>
 <8739x3ir2v.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739x3ir2v.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@deeprootsystems.com> [100604 03:17]:
> Russell King <rmk@arm.linux.org.uk> writes:
> 
> > On Thu, Jun 03, 2010 at 07:46:23PM +0300, Tony Lindgren wrote:
> >> Compiling in multiple ARM platforms is trickier, we would have to get
> >> rid of the duplicate defines like NR_IRQS, then have some common clock
> >> framework etc. Then figure out some way to get rid of Makefile.boot.
> >> Russell probably has some other things in mind that would have to be
> >> changed to make this happen.
> >
> > - Find someway to handle the wide variety of interrupt controllers.
> > - Be able to handle any multitude of V:P translations, including non-linear
> >   alongside linear transations.
> > - Different PAGE_OFFSETs
> > - Different kernel VM layouts allowing for a variety of different ioremap
> >   region sizes
> >
> > and so the list goes on...
> >
> 
> - Support for ARMv5, v6 and v7 in the same kernel image.
> 
> On davinci, we've recently run into the problem where a new SoC in the
> family is largely the same in terms of common HW blocks ands shared
> peripherals with other davincis, but they upgraded from ARMv5 to
> ARMv6.  Attempting to build a single kernel that supports ARMv5 and
> ARMv6 uncovered a pile of assumptions that v5 and v6 would never be in
> the same kernel.

Yeah we should sort that out, otherwise more things are slowly added
that makes it harder to do.

Regards,

Tony
