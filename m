Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1JYIi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:38:26 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:48813 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab1JYIiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:38:24 -0400
X-Greylist: delayed 2041 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 04:38:24 EDT
Date: Tue, 25 Oct 2011 09:04:14 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Changhwan Youn <chaos.youn@samsung.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20111025090414.4d0034ee@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20111025074532.cc8cf0d5a9611ecc1246f46d@canb.auug.org.au>
References: <20111025074532.cc8cf0d5a9611ecc1246f46d@canb.auug.org.au>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 85.13.70.251
X-SA-Exim-Rcpt-To: sfr@canb.auug.org.au, arnd@arndb.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, chaos.youn@samsung.com
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 07:45:32 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Arnd,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-exynos4/include/mach/entry-macro.S between commit
> 292b293ceef2 ("ARM: gic: consolidate PPI handling") from the arm tree and
> commit 3a0622811292 ("ARM: EXYNOS4: Add support MCT PPI for EXYNOS4212")
> from the arm-soc tree.
> 
> Again, I hacked it up (again probably incorrectly - I kept both
> additions).

I'll cook a patch for this shortly.

Thanks,

	M.
-- 
I'm the slime oozin' out from your TV set...
