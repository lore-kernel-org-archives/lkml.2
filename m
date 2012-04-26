Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab2DZUIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:08:15 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:39298 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759219Ab2DZUIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:08:11 -0400
From: Kevin Hilman <khilman@ti.com>
To: NeilBrown <neilb@suse.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC interrupts.
Organization: Texas Instruments, Inc.
References: <20120425025637.7832.14013.stgit@notabene.brown>
	<20120425030524.7832.52047.stgit@notabene.brown>
Date: Thu, 26 Apr 2012 13:08:08 -0700
In-Reply-To: <20120425030524.7832.52047.stgit@notabene.brown> (NeilBrown's
	message of "Wed, 25 Apr 2012 13:05:24 +1000")
Message-ID: <87sjfq9ryv.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> All interrupts can wake-from-sleep (I think) so it should be
> permissible to call enable_irq_wake().  Setting this flag allows that.
>
> It is needed because without this, an interrupt which is delivered
> during late suspend will get ignored but will not cause suspend to
> abort.
> If enable_irq_wake() is called and succeeds, check_wakuep_irqs()
> will abort the suspend if the interrupt has fired.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Kevin Hilman <khilman@ti.com>

Tony, should I queue this one in my OMAP PM features for v3.5 branch?
or do you want to take it?

Kevin
