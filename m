Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2AMIlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 03:41:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47253 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2AMIlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 03:41:06 -0500
Date: Fri, 13 Jan 2012 08:40:42 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Arnd Bergmann'" <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the arm-current tree with Linus'
	tree
Message-ID: <20120113084042.GB22472@flint.arm.linux.org.uk>
References: <20120113114951.7b7f131514437454e5682aa8@canb.auug.org.au> <033201ccd18e$a6bd5950$f4380bf0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033201ccd18e$a6bd5950$f4380bf0$%kim@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 09:59:49AM +0900, Kukjin Kim wrote:
> Stephen Rothwell wrote:
> > 
> > Hi Russell,
> > 
> > Today's linux-next merge of the arm-current tree got a conflict in
> > arch/arm/mach-exynos/common.c between (I think) commit 237c78beb8a9
> > ("Merge branch 'depends/rmk/for-linus' into samsung/dt") from Linus' tree
> > and commit 588ac27d3419 ("ARM: 7273/1: EXYNOS: Fix build error which was
> > from common.c and old cpu.c") from the arm-current tree.
> > 
> > So this arm-current fi is superceded by the merge above that is now in
> > Linus' tree.
> > 
> Oh, right. Now we don't need the commit 588ac27d3419.
> 
> Russell, could you please remove it in your tree?

What the bloody hell is going on with this Samsung crap?  You send me
fixes, you put them in the patch system, then you decide you don't want
them?

What the hell are you doing?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
