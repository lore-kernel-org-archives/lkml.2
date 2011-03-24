Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316Ab1CXWnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:43:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:56923 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932915Ab1CXWnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:43:18 -0400
Date: Thu, 24 Mar 2011 23:43:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ryan Mallon <ryan@bluewatersys.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 1/3] arm/gpio: Remove three copies of broken and racy
 debug code
In-Reply-To: <4D8BBA8A.3080408@bluewatersys.com>
Message-ID: <alpine.LFD.2.00.1103242342030.31464@localhost6.localdomain6>
References: <20110324212330.292903803@linutronix.de> <20110324212508.931638262@linutronix.de> <4D8BBA8A.3080408@bluewatersys.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 25 Mar 2011, Ryan Mallon wrote:

> On 03/25/2011 10:27 AM, Thomas Gleixner wrote:
> > gpiolib plus two gpio implementations in arm fiddle in the guts of
> > irq_desc in a racy and buggy way. Remove the stuff. I already told the
> > gpio folks that we can provide that information in a proper way if
> > necessary.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/arm/mach-ep93xx/gpio.c  |   39 -------------------------------------
> >  arch/arm/plat-nomadik/gpio.c |   45 -------------------------------------------
> >  drivers/gpio/gpiolib.c       |   45 -------------------------------------------
> >  3 files changed, 129 deletions(-)
> >
> > Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
> > ===================================================================
> 
> I suggested an alternative patch for the ep93xx last time round which
> keeps the information that the pin is configured as an interrupt and
> tidies the code a bit (moves the newline to the first seq_printf). My
> patch is available here:
> http://lists-archives.org/linux-kernel/27439434-arm-ep93xx-kill-another-instance-of-broken-irq_desc-fiddling.html
> 
> Could we merge that instead please.

Sure. Will pick it up.

Thanks,

	tglx
