Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0EYHZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:25:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53635 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab0EYHZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:25:31 -0400
Date: Tue, 25 May 2010 08:25:08 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: linux-next: build failure (arm tree related)
Message-ID: <20100525072508.GA7612@flint.arm.linux.org.uk>
References: <20100525165606.239a0465.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525165606.239a0465.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 04:56:06PM +1000, Stephen Rothwell wrote:
> Hi Russell,
> 
> Most (all?) of the arm builds are failing for next-20100525:
> 
> arch/arm/Kconfig:883: can't open file "arch/arm/plat-s5pc1xx/Kconfig"
> 
> I think this may be a bad merge 211cc52a36dedd1e90147af43f6ab5eeb57952ac
> ("Merge branch 'for-rmk/samsung3' of git://git.fluff.org/bjdooks/linux
> into devel-stable") which resurrected the include of
> arch/arm/plat-s5pc1xx/Kconfig after it was removed in commit
> acc84707d3487735fc666fdeab76185d086428c0 ("ARM: SAMSUNG: move S5PC100
> support from plat-s5pc1xx to plat-s5p framework").

Yea, found that last night but forgot to push the fixed tree out.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
