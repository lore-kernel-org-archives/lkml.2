Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab1JDP56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:57:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38682 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756701Ab1JDP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:57:57 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/vLPOpn9YtvtlNqByMVr/v
Date: Tue, 4 Oct 2011 08:57:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 26/30] ARM: omap: add board autoselection
Message-ID: <20111004155752.GT6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <5055144.Y0IUdMEWXQ@wuerfel>
 <20111003182649.GC6324@atomide.com>
 <201110040944.13205.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110040944.13205.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [111004 00:10]:
> On Monday 03 October 2011, Tony Lindgren wrote:
> > * Arnd Bergmann <arnd@arndb.de> [111003 02:20]:
> > > On Monday 03 October 2011 11:27:44 Cousson, Benoit wrote:
> > > > >
> > > > > In the long run, I'd hope we can just get rid of these for subarchitectures
> > > > > that support device tree probing and make the device tree based machine
> > > > > description unconditional.
> > > > 
> > > > This is really our goal, we will have soon the board-generic.c for that, 
> > > > someone will just have to migrate these ~30 board files to device tree 
> > > > DTS files 
> > > 
> > > For the purpose of build-time validation using randconfig, there is no
> > > problem in keeping some board files forever, as long as the generic board
> > > file is always built-in.
> > 
> > Yes please leave out the list so we don't need to constantly update it.
> > Let's just always build in MACH_OMAP_GENERIC.
> 
> That's what I had initially, but now that board file has become
> omap2-specific and no longer works on omap3-only or omap4-only
> configurations.

Will send a pull request for basic DT bootstrap support from Benoit
that fixes that. So maybe let's sort that out first, then always
select it?

Regards,

Tony
