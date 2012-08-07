Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab2HGLqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:46:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42727 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403Ab2HGLp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:45:59 -0400
Date: Tue, 7 Aug 2012 12:45:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807114556.GC16861@opensource.wolfsonmicro.com>
References: <20120806192209.GA14594@flint.arm.linux.org.uk>
 <20120806195352.GC16199@opensource.wolfsonmicro.com>
 <20120806213124.GB14594@flint.arm.linux.org.uk>
 <20120806220032.GD26698@opensource.wolfsonmicro.com>
 <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
 <20120807103851.GS16861@opensource.wolfsonmicro.com>
 <20120807111331.GC24257@flint.arm.linux.org.uk>
 <20120807112844.GZ16861@opensource.wolfsonmicro.com>
 <20120807113121.GD24257@flint.arm.linux.org.uk>
 <20120807113652.GA6282@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807113652.GA6282@flint.arm.linux.org.uk>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:36:52PM +0100, Russell King wrote:

> And, for those hard of thinking, I'll tell you exactly how invasive it
> is.

> 1. You modify ioport.h to add the new type.

> Yes, it's really that damned simple.  Not invasive at all.

Your step 1 is the bit that strikes me as invasive here - that's not
something I'd be touching in a stable release if I didn't have to, it's
visible to half the kernel in an area where we clearly don't have ideal
review of the code (otherwise we'd not have a problem here in the first
place) which seems totally disproportionate to the benefit here.  We're
talking about an issue which affects one device which is used only on
Marvell systems here.

I think everyone agrees that this is the best route forward for future
kernels.
