Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0KXNuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:50:52 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52533 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0KXNuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:50:51 -0500
Date: Wed, 24 Nov 2010 13:50:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [question] NR_IRQS in genirq
Message-ID: <20101124135048.GC13507@sirena.org.uk>
References: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com> <alpine.LFD.2.00.1011241416360.2900@localhost6.localdomain6> <AANLkTik5N0d9wcaiS538UWQ83E_HhXoWC8nMxVY__1+k@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik5N0d9wcaiS538UWQ83E_HhXoWC8nMxVY__1+k@mail.gmail.com>
X-Cookie: I invented skydiving in 1989!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:46:06PM +0800, Haojian Zhuang wrote:

> My hardware environment is ARM. Each machine description can specify
> nr_irqs. In my implementation of PXA, NR_IRQS is fixed for SoC
> internal IRQs. And there's some additional board IRQs, we arrange them
> between NR_IRQS and nr_irqs. So nr_irqs will be larger than NR_IRQS if
> board IRQs exists.

Most ARM platforms have come up with some Kconfig gunk to allow boards
to extend this for off-SoC GPIOs.  It'd be really nice to get rid of
NR_IRQS and stop having to worry about this at all :(
