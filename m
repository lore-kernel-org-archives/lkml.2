Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0KIQ6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:58:44 -0500
Received: from kroah.org ([198.145.64.141]:56778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab0KIQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:58:41 -0500
Date: Tue, 9 Nov 2010 08:55:09 -0800
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
Message-ID: <20101109165509.GA9698@kroah.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
 <AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
 <201011091729.17679.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011091729.17679.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:29:17PM +0100, Arnd Bergmann wrote:
> On Tuesday 09 November 2010, Felipe Contreras wrote:
> > Felipe Contreras (14):
> >       Revert "staging: tidspbridge - update Kconfig to select IOMMU module"
> >       Revert "staging: tidspbridge - remove dmm custom module"
> >       Revert "staging: tidspbridge - deprecate reserve/unreserve_memory funtions"
> >       Revert "staging: tidspbridge - remove reserved memory clean up"
> >       Revert "staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct"
> >       Revert "staging: tidspbridge - move all iommu related code to a new file"
> >       Revert "staging: tidspbridge - remove hw directory"
> >       Revert "staging: tidspbridge - fix mmufault support"
> >       Revert "staging: tidspbridge - remove custom mmu code from tiomap3430.c"
> >       Revert "staging: tidspbridge - rename bridge_brd_mem_map/unmap to a proper name"
> >       Revert "staging: tidspbridge - move shared memory iommu maps to tiomap3430.c"
> >       Revert "staging: tidspbridge: replace iommu custom for opensource implementation"
> 
> That adds quite a lot of crap back in that was removed by Fernando earlier:
> 
>  44 files changed, 3733 insertions(+), 847 deletions(-)
> 
> It may have been premature to merge the patches as you say, but now that
> they are in, I'd vote for giving Fernando a chance to fix up any damage
> that was done in the process rather than just reverting all the useful
> changes.

In looking at this further, I agree.

Felipe, are all of these really needing to be reverted?  How about
picking out the functional changes that need to be resolved instead of
just rolling back everything that has been done here.  Surely not all of
these are wrong, right?

thanks,

greg k-h
