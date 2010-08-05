Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab0HEOns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:43:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34524 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933394Ab0HEOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:43:40 -0400
Date: Thu, 5 Aug 2010 15:43:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] lp3971: remove unnecessary ret value checking in
	lp3971_i2c_write()
Message-ID: <20100805144336.GA26801@opensource.wolfsonmicro.com>
References: <1280979638.1238.2.camel@mola> <20100805121145.GD13146@rakim.wolfsonmicro.main> <AANLkTimR8J_LqGweRpgddN3qv0oXGjnWGGiTBHQHLWi6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimR8J_LqGweRpgddN3qv0oXGjnWGGiTBHQHLWi6@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:22:13PM +0800, Axel Lin wrote:
> 2010/8/5 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > but can I once more renew my request that you make some effort to
> > provide subject lines for your patches which are consistent with the
> > standard used for the area of the kernel you're submitting to?

> I think we have communication problem.
> I thought the subject "[PATCH 1/2] lp3971: remove unnecessary ret
> value checking in lp3971_i2c_write()"
> is pretty clear.
> Or do you mean something else?

In this case pretty much every regulator API patch has a subject line
starting "regulator: " but none of your patches do this, you have
created your own style which you use over all your patches.
