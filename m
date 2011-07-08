Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1GHKOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:14:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44045 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab1GHKOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:14:16 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jul 2011 15:44:02 +0530
Subject: RE: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design
	plan
Thread-Topic: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design
	plan
Thread-Index: Acw9Vmh9DCmbATfuQJinpPhzmPgqoQAAK63A
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E94030259CDC4@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E94030259CD17@dbde02.ent.ti.com>
 <20110708100410.GA4957@n2100.arm.linux.org.uk>
In-Reply-To: <20110708100410.GA4957@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Friday, July 08, 2011 3:34 PM
> To: Raju, Sundaram
> Cc: linux-arm-kernel@lists.infradead.org; linux-omap@vger.kernel.org; Dan;
> Shilimkar, Santosh; linux-kernel@vger.kernel.org
> Subject: Re: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design
> plan
> 
> On Fri, Jul 08, 2011 at 01:52:17PM +0530, Raju, Sundaram wrote:
> > I am planning to move TI SDMA driver in OMAP tree
> > into the dmaengine framework.
> >
> > The first immediate issue of concern I noticed is the
> > huge number of client drivers that use the existing SDMA driver.
> > More than 15 client drivers are using the current SDMA driver.
> >
> > Moving the SDMA driver along with all of these client drivers at a
> > single stretch seems a humungous task.
> > I noticed a model in the existing DMA drivers in dmaengine
> > framework that will over come this issue.
> 
> It _is_ sane to build a dmaengine driver on top of the existing SoC
> private API, then convert the drivers to DMA engine, and then cleanup
> the resulting DMA engine driver.

Yes, that is what I thought. Thanks.

> 
> What we must make sure though is that the DMA engine slave API (which
> isn't well documented) is correctly implemented before drivers are
> converted over to use the DMA engine support code, otherwise we may
> end up with lots of drivers that require re-fixing several times over.
>

Very true! Agreed!
I will send over the patches for review once I am done with testing.

Regards,
Sundaram
