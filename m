Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab1LNUP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:15:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49728 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119Ab1LNUPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:15:24 -0500
Date: Wed, 14 Dec 2011 15:08:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 14 (phy vs. bcma)
Message-ID: <20111214200841.GC2607@tuxdriver.com>
References: <20111214182643.06262d032298672024ba8a76@canb.auug.org.au>
 <4EE90EB1.4060903@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE90EB1.4060903@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 01:01:37PM -0800, Randy Dunlap wrote:
> On 12/13/2011 11:26 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20111213:
> 
> 
> drivers/built-in.o: In function `b43_nphy_pmu_spur_avoid.clone.8':
> phy_n.c:(.text+0x1589d8): undefined reference to `bcma_chipco_pll_write'
> phy_n.c:(.text+0x1589e9): undefined reference to `bcma_chipco_pll_write'
> phy_n.c:(.text+0x1589fa): undefined reference to `bcma_chipco_pll_write'
> phy_n.c:(.text+0x158a08): undefined reference to `bcma_chipco_pll_write'
> phy_n.c:(.text+0x158a1d): undefined reference to `bcma_chipco_pll_write'
> drivers/built-in.o:phy_n.c:(.text+0x158a2e): more undefined references to `bcma_chipco_pll_write' follow
> 
> 
> BCMA is not enabled.
> Full randconfig file is attached.

I've already merged a patch to address this.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
