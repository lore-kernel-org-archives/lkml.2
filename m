Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2IPUi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 16:38:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23521 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752636Ab2IPUiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 16:38:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/R9c1X6aYqv95sSX97NDYG
Date: Sun, 16 Sep 2012 13:38:50 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH 17/24] ARM: OMAP: use __iomem pointers for MMIO
Message-ID: <20120916203850.GI4521@atomide.com>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-18-git-send-email-arnd@arndb.de>
 <20120915181057.GH4521@atomide.com>
 <201209152014.37989.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209152014.37989.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120915 13:15]:
> On Saturday 15 September 2012, Tony Lindgren wrote:
> > With my patches, this is now all omap1 specific and
> > moved to arch/arm/mach-omap1/include/mach/hardware.h.
> > It's probably easiest to just update this patch on
> > top of the hardware.h changes I've done.
> 
> Yes, sounds good. Do you want to send a patch for that
> and let me drop this one then?

Yes I can pick this one and update it against one of my
branches to avoid merge conflicts.

Regards,

Tony
