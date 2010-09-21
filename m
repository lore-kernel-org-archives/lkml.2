Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab0IUPOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:14:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36251 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab0IUPOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:14:38 -0400
Date: Tue, 21 Sep 2010 11:08:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: linux-next: manual merge of the wireless tree with Linus' tree
Message-ID: <20100921150820.GA2448@tuxdriver.com>
References: <20100921120919.a38723d3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921120919.a38723d3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 12:09:19PM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless tree got a conflict in
> arch/arm/mach-omap2/board-omap3pandora.c between commit
> 79ccf549b33c613b57eebcb03f8b24644c545a88 ("omap3: pandora: add NAND and
> wifi support") from Linus' tree and commit
> 664279b5121b480f31ffecf202cd2d1591ff356e ("wl12xx: make wl12xx.h common
> to both spi and sdio") from the wireless tree.
> 
> The wireless tree commit copied the include/linux/spi/wl12xx.h to
> include/linux but did not remove the spi/ one.  Later patches modified
> only the new one ... I fixed the above conflict (see below) on the
> assumption that the spi/ version of the header file should have been
> removed.

Hmmmm...not sure how the delete part of the move got lost...  I'll fix
it up.

Thanks for letting me know!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
