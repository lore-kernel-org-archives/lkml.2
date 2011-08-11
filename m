Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1HKUCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:02:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42538 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1HKUCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:02:33 -0400
Date: Thu, 11 Aug 2011 21:02:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: Fix <mach/gpio.h> to have necessary
	#includes
Message-ID: <20110811200210.GB24166@n2100.arm.linux.org.uk>
References: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CD0@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CD0@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:49:47PM -0700, Stephen Warren wrote:
> Russell King wrote at Thursday, August 11, 2011 1:36 PM:
> > On Thu, Aug 11, 2011 at 12:05:52PM -0600, Stephen Warren wrote:
> > > Without this, EINVAL isn't defined, and type bool isn't declared.
> > > This leads to compilation failures.
> > 
> > An alternative approach would be to convert tegra to be able to use
> > the gpiolib __gpio_to_irq() for the on-SoC stuff, and eliminate
> > irq_to_gpio().
> > 
> > Would it be possible to do that instead?
> 
> That should work too.
> 
> I posted a couple patches last Friday to remove irq_to_gpio:
> 
> https://lkml.org/lkml/2011/8/5/343
> https://lkml.org/lkml/2011/8/5/342
> 
> Later in the thread, you said you would merge them into your branch to
> avoid merge conflicts with the other GPIO work you were doing.

I suggested it would be a good idea.  Now that I've published those
changes, any chance of having some updated patches in the patch system
please?

> For gpio_to_irq, yes, I believe we get rid of it pretty easily; we'd
> just need to implement gpio-tegra.c's gpio_chip.to_irq function. Should
> I cook up a patch based on top of linux-next plus the two patches above
> to do that instead?

Yes please, again eventually to the patch system once Grant has acked it
to avoid the otherwise certain conflicts.

Thanks for doing this.
