Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1GHK2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:28:01 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22812 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757Ab1GHK16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:27:58 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+LrTa/p0EDUEza8l9obzMK
Date: Fri, 8 Jul 2011 03:27:51 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design
 plan
Message-ID: <20110708102751.GT5783@atomide.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E94030259CD17@dbde02.ent.ti.com>
 <20110708100410.GA4957@n2100.arm.linux.org.uk>
 <E0D41E29EB0DAC4E9F3FF173962E9E94030259CDC4@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E94030259CDC4@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Raju, Sundaram <sundaram@ti.com> [110708 03:09]:
> > -----Original Message-----
> > From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> > Sent: Friday, July 08, 2011 3:34 PM
> > To: Raju, Sundaram
> > Cc: linux-arm-kernel@lists.infradead.org; linux-omap@vger.kernel.org; Dan;
> > Shilimkar, Santosh; linux-kernel@vger.kernel.org
> > Subject: Re: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design
> > plan
> > 
> > On Fri, Jul 08, 2011 at 01:52:17PM +0530, Raju, Sundaram wrote:
> > > I am planning to move TI SDMA driver in OMAP tree
> > > into the dmaengine framework.
> > >
> > > The first immediate issue of concern I noticed is the
> > > huge number of client drivers that use the existing SDMA driver.
> > > More than 15 client drivers are using the current SDMA driver.
> > >
> > > Moving the SDMA driver along with all of these client drivers at a
> > > single stretch seems a humungous task.
> > > I noticed a model in the existing DMA drivers in dmaengine
> > > framework that will over come this issue.
> > 
> > It _is_ sane to build a dmaengine driver on top of the existing SoC
> > private API, then convert the drivers to DMA engine, and then cleanup
> > the resulting DMA engine driver.
> 
> Yes, that is what I thought. Thanks.

Yes that's what we did with the gpiolib changes. That allows then
converting the drivers over to the DMA engine API one function at
a time (or one driver at a time).

Regards,

Tony
