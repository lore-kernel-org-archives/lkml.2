Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab0GVPFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:05:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53541 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752130Ab0GVPFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:05:35 -0400
Date: Thu, 22 Jul 2010 16:05:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>, linux-mm@kvack.org,
        Pawel Osciak <p.osciak@samsung.com>,
        "'Xiaolin Zhang'" <xiaolin.zhang@intel.com>,
        "'Hiremath Vaibhav'" <hvaibhav@ti.com>,
        "'Robert Fekete'" <robert.fekete@stericsson.com>,
        "'Marcus Lorentzon'" <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
Message-ID: <20100722150532.GA16119@rakim.wolfsonmicro.main>
References: <20100721182457.GE10930@sirena.org.uk>
 <op.vf7h6ysh7p4s8u@pikus>
 <20100722090602.GF10930@sirena.org.uk>
 <000901cb297f$e28f2b10$a7ad8130$%szyprowski@samsung.com>
 <20100722105203.GD4737@rakim.wolfsonmicro.main>
 <op.vf8sxqro7p4s8u@pikus>
 <20100722124559.GH4737@rakim.wolfsonmicro.main>
 <op.vf8x60wi7p4s8u@pikus>
 <20100722134056.GJ4737@rakim.wolfsonmicro.main>
 <op.vf82j5m17p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vf82j5m17p4s8u@pikus>
X-Cookie: All men have the right to wait in line.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 04:58:43PM +0200, Michał Nazarewicz wrote:
> On Thu, 22 Jul 2010 15:40:56 +0200, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> >Yeah, agreed though I'm not convinced we can't do it via userspace
> >(initrd would give us a chance to do stuff early) or just kernel
> >rebuilds.

> If there's any other easy way of overwriting platform's default I'm happy
> to listen. :)

Netlink or similar, for example?

> >Yes, exactly - probably you can even have a default region backed by
> >normal vmalloc() RAM which would at least be able to take a stab at
> >working by default.

> Not sure what you mean here.  vmalloc() allocated buffers cannot be used
> with CMA since they are not contiguous in memory.

Sorry, thinko - I just meant allocated at runtime.  It'd fail a a lot of
the time so might not be worth bothering.
