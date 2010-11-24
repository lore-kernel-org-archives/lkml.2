Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0KXOAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:00:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41770 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752640Ab0KXOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:00:52 -0500
Date: Wed, 24 Nov 2010 14:00:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [question] NR_IRQS in genirq
Message-ID: <20101124140048.GG24970@rakim.wolfsonmicro.main>
References: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com>
 <alpine.LFD.2.00.1011241416360.2900@localhost6.localdomain6>
 <AANLkTik5N0d9wcaiS538UWQ83E_HhXoWC8nMxVY__1+k@mail.gmail.com>
 <20101124135048.GC13507@sirena.org.uk>
 <alpine.LFD.2.00.1011241453330.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011241453330.2900@localhost6.localdomain6>
X-Cookie: Made with real ingredients.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 02:54:38PM +0100, Thomas Gleixner wrote:
> On Wed, 24 Nov 2010, Mark Brown wrote:
> > On Wed, Nov 24, 2010 at 09:46:06PM +0800, Haojian Zhuang wrote:

> > Most ARM platforms have come up with some Kconfig gunk to allow boards
> > to extend this for off-SoC GPIOs.  It'd be really nice to get rid of
> > NR_IRQS and stop having to worry about this at all :(

> I mean with sparse_irq you can set NR_IRQS insanely high w/o
> increasing memory consumption. That's the whole point.

Yeah, I was just pointing out common practice on ARM (sparse IRQ isn't
widely enough deployed there :/ ).

Would it be worth having sparse_irq change the default NR_IRQS to be
something suitably large - there doesn't seem any point in having
platforms using it each pick their own particular definition of insanely
high?  I'll take a look and cook up a patch unless I can spot anything
silly about that by myself.
