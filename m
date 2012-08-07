Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2HGLbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:31:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56139 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2HGLbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:31:35 -0400
Date: Tue, 7 Aug 2012 12:31:21 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807113121.GD24257@flint.arm.linux.org.uk>
References: <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com> <20120806155805.GR16861@opensource.wolfsonmicro.com> <20120806192209.GA14594@flint.arm.linux.org.uk> <20120806195352.GC16199@opensource.wolfsonmicro.com> <20120806213124.GB14594@flint.arm.linux.org.uk> <20120806220032.GD26698@opensource.wolfsonmicro.com> <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com> <20120807103851.GS16861@opensource.wolfsonmicro.com> <20120807111331.GC24257@flint.arm.linux.org.uk> <20120807112844.GZ16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807112844.GZ16861@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:28:44PM +0100, Mark Brown wrote:
> On Tue, Aug 07, 2012 at 12:13:31PM +0100, Russell King wrote:
> > On Tue, Aug 07, 2012 at 11:38:51AM +0100, Mark Brown wrote:
> 
> > > If nothing else this seems much more suitable for stable and -rc (the
> > > bug has been there since v3.4).
> 
> > There is no need for such hacks.
> 
> Please read the text you quoted above.

I did.

> > There's no need to botch this in any way what so ever, or invent some
> > other solution only to have to (probably never) rework it.
> 
> The changes you're suggesting are extremely invasive for stable
> especially given that we have a simple, driver local, fix available

*Rubbish*.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
