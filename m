Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423230Ab2JaQQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:16:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37048 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935768Ab2JaQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:16:16 -0400
X-Sasl-enc: HQ40vrfD9AjZrrRw2AOhDdC1bszd14ivnW//p//tjaET 1351700175
Date: Wed, 31 Oct 2012 09:16:14 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Clark <rob@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the staging
 tree
Message-ID: <20121031161614.GF31804@kroah.com>
References: <20121031161921.3c9a46bd03f5864eed88fc87@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031161921.3c9a46bd03f5864eed88fc87@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 04:19:21PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap2/drm.c between commit 5e3b08749951 ("staging:
> drm/omap: add support for ARCH_MULTIPLATFORM") from the staging tree and
> commit 2a296c8f89bc ("ARM: OMAP: Make plat/omap_hwmod.h local to
> mach-omap2") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks for this.

greg k-h
