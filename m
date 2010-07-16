Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab0GPSkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:40:42 -0400
Received: from relais.videotron.ca ([24.201.245.36]:27223 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab0GPSkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:40:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 16 Jul 2010 14:40:38 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for
 defconfig
In-reply-to: <20100716183028.GB26854@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.1007161439240.10598@xanadu.home>
References: <20100713230352.6781.18644.stgit@angua>
 <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
 <AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com>
 <alpine.LFD.2.00.1007161406120.10598@xanadu.home>
 <20100716183028.GB26854@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010, Russell King - ARM Linux wrote:

> On Fri, Jul 16, 2010 at 02:19:31PM -0400, Nicolas Pitre wrote:
> > For example, if I want CONFIG_MTD_CMDLINE_PARTS=y, the system may be 
> > smart enough to notice and automatically enable CONFIG_MTD and 
> > CONFIG_MTD_PARTITIONS without having to carry those in the defconfig.
> 
> How do you sort out something like this:
> 
> config FOO
> 	bool "Foo"
> 	depends on (A && B) || C

DOH.


Nicolas
