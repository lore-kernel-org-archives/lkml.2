Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0GHKOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 06:14:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54507 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab0GHKOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 06:14:37 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+BVMlbemo7fgnl9OKH0e1G
Date: Thu, 8 Jul 2010 13:14:23 +0300
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       Mike Rapoport <mike@compulab.co.il>
Subject: Re: linux-next: manual merge of the omap tree with the arm tree
Message-ID: <20100708101422.GD1920@atomide.com>
References: <20100708113730.c2683125.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708113730.c2683125.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [100708 04:31]:
> Hi all,
> 
> Today's linux-next merge of the omap tree got conflicts in
> arch/arm/mach-omap2/board-3430sdp.c,
> arch/arm/mach-omap2/board-3630sdp.c,
> arch/arm/mach-omap2/board-am3517evm.c,
> arch/arm/mach-omap2/board-cm-t35.c,
> arch/arm/mach-omap2/board-devkit8000.c,
> arch/arm/mach-omap2/board-igep0020.c,
> arch/arm/mach-omap2/board-ldp.c,
> arch/arm/mach-omap2/board-omap3beagle.c,
> arch/arm/mach-omap2/board-omap3evm.c,
> arch/arm/mach-omap2/board-omap3pandora.c,
> arch/arm/mach-omap2/board-omap3touchbook.c,
> arch/arm/mach-omap2/board-overo.c,
> arch/arm/mach-omap2/board-zoom2.c and
> arch/arm/mach-omap2/board-zoom3.c
> between commit 1e6d923b4e5729b73518d241edf87a3ab2d5688c ("ARM: OMAP:
> Convert to use ->reserve method to reserve boot time memory") from the
> arm tree and commit c752ab9d5a5b6899f14fe1c6643c0fe0b499a4ba ("omap3:
> introduce omap3_map_io") from the omap tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks, I'll merge with Russell's lmb branch when I
have confirmation that it will stay static.
 
> P.S. Tony, that omap tree commit has a fairly unuseful changelog and no
> SOB from its purported author ...

Oops, I'll check that.

Regards,

Tony
