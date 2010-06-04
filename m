Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0FDE7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:59:45 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56798 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0FDE7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:59:44 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/WF5qDlxIpt27mWRLSLqEz
Date: Fri, 4 Jun 2010 07:59:18 +0300
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100604045913.GD6499@atomide.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603164623.GM30622@atomide.com>
 <20100603181303.GB25779@flint.arm.linux.org.uk>
 <20100603213337.GB6499@atomide.com>
 <alpine.LFD.2.00.1006031833360.24526@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031833360.24526@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre <nico@fluxnic.net> [100604 01:40]:
> 
> Like I said, there is an effort to gradually overcome those issues one 
> by one.

Unfortunately the same time we are slowly adding more and more ifdef else
code that adds new blockers to compile in multiple ARM platforms into
the same kernel. Some of the ones I've ran into over past few months are
CONFIG_HAS_TLS_REG, CONFIG_VFPv3 and CONFIG_SMP. The first two are
fixable though.

Anyways, once we get the TLS and VFPv3 issues sorted out, we
can do ARMv6 and ARMv7 booting binaries so I'll be able to whine
about any new blockers getting added :)

Regards,

Tony
