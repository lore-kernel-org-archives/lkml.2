Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2HGL2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:28:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59506 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab2HGL2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:28:46 -0400
Date: Tue, 7 Aug 2012 12:28:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807112844.GZ16861@opensource.wolfsonmicro.com>
References: <20120806154619.GO16861@opensource.wolfsonmicro.com>
 <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com>
 <20120806155805.GR16861@opensource.wolfsonmicro.com>
 <20120806192209.GA14594@flint.arm.linux.org.uk>
 <20120806195352.GC16199@opensource.wolfsonmicro.com>
 <20120806213124.GB14594@flint.arm.linux.org.uk>
 <20120806220032.GD26698@opensource.wolfsonmicro.com>
 <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
 <20120807103851.GS16861@opensource.wolfsonmicro.com>
 <20120807111331.GC24257@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807111331.GC24257@flint.arm.linux.org.uk>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:13:31PM +0100, Russell King wrote:
> On Tue, Aug 07, 2012 at 11:38:51AM +0100, Mark Brown wrote:

> > If nothing else this seems much more suitable for stable and -rc (the
> > bug has been there since v3.4).

> There is no need for such hacks.

Please read the text you quoted above.

> There's no need to botch this in any way what so ever, or invent some
> other solution only to have to (probably never) rework it.

The changes you're suggesting are extremely invasive for stable
especially given that we have a simple, driver local, fix available
which is already deployed and used in other drivers in the same kernels
(at least in v3.5 anyway, the change introducing the issue got pushed
into v3.4 unexpectedly so the fix didn't make it).  It would be worrying
if such changes were being accepted into stable.

I agree that the changes you're suggeting seem sensible for v3.7 if
someone wants to work on them, possibly even v3.6 if people are willing
to do something like that after the merge window, but we've got an issue
in stable here which is the most urgent thing.
