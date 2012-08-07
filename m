Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2HGLoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:44:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56206 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2HGLo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:44:29 -0400
Date: Tue, 7 Aug 2012 12:44:15 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807114415.GG24257@flint.arm.linux.org.uk>
References: <20120806192209.GA14594@flint.arm.linux.org.uk> <20120806195352.GC16199@opensource.wolfsonmicro.com> <20120806213124.GB14594@flint.arm.linux.org.uk> <20120806220032.GD26698@opensource.wolfsonmicro.com> <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com> <20120807103851.GS16861@opensource.wolfsonmicro.com> <20120807111331.GC24257@flint.arm.linux.org.uk> <20120807112844.GZ16861@opensource.wolfsonmicro.com> <20120807113121.GD24257@flint.arm.linux.org.uk> <20120807113801.GB16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807113801.GB16861@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:38:02PM +0100, Mark Brown wrote:
> On Tue, Aug 07, 2012 at 12:31:21PM +0100, Russell King wrote:
> > On Tue, Aug 07, 2012 at 12:28:44PM +0100, Mark Brown wrote:
> 
> > > The changes you're suggesting are extremely invasive for stable
> > > especially given that we have a simple, driver local, fix available
> 
> > *Rubbish*.
> 
> This isn't helpful or constructive...
> 
> Which bit of the above are you referring to here?  If it's the having a
> fix bit then as pointed out repeatedly now in this and the previous
> thread we've got the separete resource tree approach implemented in
> stable right now making actual systems run.

All of your above statement.  It is, basically, completely wrong, and
shows that you haven't thought about the solution I'm proposing at all.

I've shown you in simple steps how easy it is.  It is not invasive.  It
is not complex.  It is local to the affected drivers.  So, all your
points above are plain wrong.  Hence "rubbish".

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
