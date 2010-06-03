Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0FCVeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:34:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55134 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab0FCVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:34:03 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ajK8na0TDVQp1IeRDNOZy
Date: Fri, 4 Jun 2010 00:33:39 +0300
From: Tony Lindgren <tony@atomide.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603213337.GB6499@atomide.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603164623.GM30622@atomide.com>
 <20100603181303.GB25779@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603181303.GB25779@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King <rmk@arm.linux.org.uk> [100603 21:07]:
> On Thu, Jun 03, 2010 at 07:46:23PM +0300, Tony Lindgren wrote:
> > Compiling in multiple ARM platforms is trickier, we would have to get
> > rid of the duplicate defines like NR_IRQS, then have some common clock
> > framework etc. Then figure out some way to get rid of Makefile.boot.
> > Russell probably has some other things in mind that would have to be
> > changed to make this happen.
> 
> - Find someway to handle the wide variety of interrupt controllers.
> - Be able to handle any multitude of V:P translations, including non-linear
>   alongside linear transations.
> - Different PAGE_OFFSETs
> - Different kernel VM layouts allowing for a variety of different ioremap
>   region sizes

Some of these could be handled by allowing building a seprate instance
for each platform compiled in. Maybe we could set them up with symlinks.

How about a minimal generic relocatable ARM kernel and then we load the
platform support as a module from ramdisk? :)
 
> and so the list goes on...

Yeah..
 
> > That way maybe you can wait a bit longer for the other defconfigs
> > and as an extra bonus I won't get flamed for removing these omap
> > defconfigs ;)
> 
> Note that Linus is talking about removing all but one or two ARM
> defconfigs - which means your omap3_defconfig will probably be
> eventually culled.

Yes but I also think we need to do something about this.

Regards,

Tony
