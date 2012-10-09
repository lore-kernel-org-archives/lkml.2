Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2JIGYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:24:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56138 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651Ab2JIGYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:24:09 -0400
Date: Tue, 9 Oct 2012 15:23:57 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: Convert tps6586x to irq_domain
Message-ID: <20121009062355.GJ8237@opensource.wolfsonmicro.com>
References: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com>
 <1349712805-10014-2-git-send-email-ldewangan@nvidia.com>
 <20121009060641.GE8237@opensource.wolfsonmicro.com>
 <5073BAA8.4060404@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5073BAA8.4060404@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:18:24AM +0530, Laxman Dewangan wrote:
> On Tuesday 09 October 2012 11:36 AM, Mark Brown wrote:

> >but can you convert to regmap_irq?

> Yes, the motivation was this when I started this cleanups but found
> that there is 4 interrupt status and 5 interrupt mask register.
> Probably we need to pass the number of interrupt status and
> interrupt mask register to expand the regmap-irq framework to handle
> this case also. If it is fine then I can work towards that.

Can you explain in more detail - I guess there's a different mapping of
the bits into the registers for mask and status (in which case the
generic code just won't work anyway).
