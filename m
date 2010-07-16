Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0GPScA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:32:00 -0400
Received: from relais.videotron.ca ([24.201.245.36]:11279 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749Ab0GPSb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:31:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 16 Jul 2010 14:31:44 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for
 defconfig
In-reply-to: <AANLkTilY0rvbp7brGsnyuGhPjFvpVYInNWlAlf5tT4zG@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1007161429121.10598@xanadu.home>
References: <20100713230352.6781.18644.stgit@angua>
 <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
 <AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com>
 <alpine.LFD.2.00.1007161406120.10598@xanadu.home>
 <AANLkTilY0rvbp7brGsnyuGhPjFvpVYInNWlAlf5tT4zG@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010, Grant Likely wrote:
> On Fri, Jul 16, 2010 at 12:19 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> > For example, if I want CONFIG_MTD_CMDLINE_PARTS=y, the system may be
> > smart enough to notice and automatically enable CONFIG_MTD and
> > CONFIG_MTD_PARTITIONS without having to carry those in the defconfig.
> 
> I fully agree.  However, the warnings make the system work now while
> we wait for a full solver to be implemented.

Why can't the tool just _select_ the option it is warning about when a 
dependency is not met?  That shouldn't require a full solver.


Nicolas
