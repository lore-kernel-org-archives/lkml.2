Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0GVJGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:06:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45597 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab0GVJGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:06:16 -0400
Date: Thu, 22 Jul 2010 10:06:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Micha?? Nazarewicz <m.nazarewicz@samsung.com>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-mm@kvack.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
Message-ID: <20100722090602.GF10930@sirena.org.uk>
References: <cover.1279639238.git.m.nazarewicz@samsung.com> <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com> <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com> <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com> <op.vf5o28st7p4s8u@pikus> <20100721135229.GC10930@sirena.org.uk> <op.vf66mxka7p4s8u@pikus> <20100721182457.GE10930@sirena.org.uk> <op.vf7h6ysh7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vf7h6ysh7p4s8u@pikus>
X-Cookie: He who laughs last didn't get the joke.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 08:41:12PM +0200, Micha?? Nazarewicz wrote:
> On Wed, 21 Jul 2010 20:24:58 +0200, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> >> I am currently working on making the whole thing more dynamic.  I imagine

> > Yes, I think it will be much easier to be able to grab the regions at
> > startup but hopefully the allocation within those regions can be made
> > much more dynamic.  This would render most of the configuration syntax
> > unneeded.

> Not sure what you mean by the last sentence.  Maybe we have different
> things in mind?

I mean that if the drivers are able to request things dynamically and
have some knowledge of their own requirements then that removes the need
to manually specify exactly which regions go to which drivers which
means that most of the complexity of the existing syntax is not needed
since it can be figured out at runtime.
