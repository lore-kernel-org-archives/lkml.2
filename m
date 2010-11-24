Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0KXNys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:54:48 -0500
Received: from www.tglx.de ([62.245.132.106]:41209 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab0KXNyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:54:47 -0500
Date: Wed, 24 Nov 2010 14:54:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [question] NR_IRQS in genirq
In-Reply-To: <20101124135048.GC13507@sirena.org.uk>
Message-ID: <alpine.LFD.2.00.1011241453330.2900@localhost6.localdomain6>
References: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com> <alpine.LFD.2.00.1011241416360.2900@localhost6.localdomain6> <AANLkTik5N0d9wcaiS538UWQ83E_HhXoWC8nMxVY__1+k@mail.gmail.com> <20101124135048.GC13507@sirena.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Mark Brown wrote:

> On Wed, Nov 24, 2010 at 09:46:06PM +0800, Haojian Zhuang wrote:
> 
> > My hardware environment is ARM. Each machine description can specify
> > nr_irqs. In my implementation of PXA, NR_IRQS is fixed for SoC
> > internal IRQs. And there's some additional board IRQs, we arrange them
> > between NR_IRQS and nr_irqs. So nr_irqs will be larger than NR_IRQS if
> > board IRQs exists.
> 
> Most ARM platforms have come up with some Kconfig gunk to allow boards
> to extend this for off-SoC GPIOs.  It'd be really nice to get rid of
> NR_IRQS and stop having to worry about this at all :(

I mean with sparse_irq you can set NR_IRQS insanely high w/o
increasing memory consumption. That's the whole point.

Thanks,

	tglx
