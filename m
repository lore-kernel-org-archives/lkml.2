Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1JXUwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:52:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35942 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1JXUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:52:24 -0400
Date: Mon, 24 Oct 2011 21:51:58 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Glexiner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Changhwan Youn <chaos.youn@samsung.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20111024205158.GC32545@flint.arm.linux.org.uk>
References: <20111025074532.cc8cf0d5a9611ecc1246f46d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025074532.cc8cf0d5a9611ecc1246f46d@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 07:45:32AM +1100, Stephen Rothwell wrote:
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

Argh, noooo, not another conflict.

It looks like merging the PPI stuff was a bad move (despite pressure from
tglx to do so.)  Unfortunately, it's in my published stable branch so it
can't be dropped.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
