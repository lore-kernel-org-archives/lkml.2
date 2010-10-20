Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0JTJxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:53:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45781 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0JTJxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:53:45 -0400
Date: Wed, 20 Oct 2010 10:53:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, mattw@codeaurora.org,
        akpm@linux-foundation.org, Suman Anna <s-anna@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
Message-ID: <20101020095303.GA21242@n2100.arm.linux.org.uk>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <1287531090.9245.139.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287531090.9245.139.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 04:31:30PM -0700, Daniel Walker wrote:
> On Mon, 2010-10-18 at 09:44 +0200, Ohad Ben-Cohen wrote:
> > OMAP4 introduces a Spinlock hardware module, which provides hardware
> > assistance for synchronization and mutual exclusion between heterogeneous
> > processors and those not operating under a single, shared operating system
> > (e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP).
> > 
> > The intention of this hardware module is to allow remote processors,
> > that have no alternative mechanism to accomplish synchronization and mutual
> > exclusion operations, to share resources (such as memory and/or any other
> > hardware resource).
> > 
> > This patchset adds a new misc driver for this OMAP hwspinlock module.
> 
> Does this code interface with some hardware unit (other than the other
> processors) to accomplish this locking ?
> 
> The reason I ask is because MSM has similar code, and from what I can
> tell the MSM version has some structures in memory but that's all. It
> just operates on the structures in memory.
> 
> It might be worth looking over the two implementation so we aren't both
> remaking the wheel.

Ohad's message to which you replied had:

To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        akpm@linux-foundation.org, Suman Anna <s-anna@ti.com>

Yours has:

To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Hari Kanigeri <h-kanigeri2@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, mattw@codeaurora.org,
        akpm@linux-foundation.org, Suman Anna <s-anna@ti.com>,
        mattw@codeaurora.orgmattw, linux-arm-kernel@lists.infradead.org

which includes an invalid address "mattw@codeaurora.orgmattw".  Is there
a reason why you're excluding the linux-omap list from your message and
subsequent discussion?
