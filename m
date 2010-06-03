Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0FCVRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:17:38 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59955 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0FCVRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:17:37 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18OOZTPVfRaCsnY/DuFVWWa
Date: Fri, 4 Jun 2010 00:17:09 +0300
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603211707.GA6499@atomide.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603181010.GA25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
 <20100603185333.GD25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
 <20100603194559.GF25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [100603 23:30]:
> 
> and now you'd be able to basically generate a OMAP3EVM .config file by 
> just running "allnoconfig" on that Kconfig.omap3_evm file. But it would 
> only have to select the parts that are specific for the EVM platform, 
> because the generic OMAP3 support would be picked by the Kconfig.omap3 
> file, which in turn would not have to worry about the generic ARM parts 
> etc.
> 
> See?

Sounds like a good improvment to me.

Tony
