Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1LGT2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:28:50 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43729 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756664Ab1LGT2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:28:49 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195XfK+d0vKhmXV0RzsShW3
Date: Wed, 7 Dec 2011 11:28:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20111207192842.GF31337@atomide.com>
References: <20111128105633.8a8c06afce3cdccb1ce0d7b7@canb.auug.org.au>
 <201111281911.36341.arnd@arndb.de>
 <1322553977.1869.1.camel@deskari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322553977.1869.1.camel@deskari>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [111128 23:31]:
> Hi,
> 
> On Mon, 2011-11-28 at 19:11 +0000, Arnd Bergmann wrote:
> > On Sunday 27 November 2011, Stephen Rothwell wrote:
> > > Today's linux-next merge of the arm-soc tree got a conflict in
> > > arch/arm/plat-omap/include/plat/common.h between commit 4e65331c6bb4
> > > ("ARM: 7159/1: OMAP: Introduce local common.h files") from the  tree and
> > > commit 13662dc5b177 ("ARM: OMAP: HWMOD: Unify DSS resets for OMAPs") from
> > > the arm-soc tree.
> > > 
> > > I did the obvious fixup (see below) and can carry the fix as necessary.
> > 
> > Your fix looks technically correct, thanks!
> > 
> > Tony, I believe what you actually want here is to move omap_dss_reset
> > into mach-omap2/common.h, right?
> 
> omap_dss_reset will never be used by omap1 boards, so I think
> mach-omap2/common.h would be a good place for it.

Sorry for the delay. Yes mach-omap2/common.h is the way to go. That
comes from Russells devel-stable branch and was needed for the ARM
restart changes.

Tomi, if you need to, you can base your branch on commit
deee6d5359969a0ce4e2760cfd7b9f379bd5698a in Russell's devel-stable
branch.

Regards,

Tony
