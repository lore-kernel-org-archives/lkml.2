Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2APK4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:56:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43404 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2APK4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:56:15 -0500
From: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
Thread-Topic: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
Thread-Index: AQHM0bzZ3HvTVi65q0q5jVepkBzZG5YKErvggABU+ICABG9BcA==
Date: Mon, 16 Jan 2012 10:56:11 +0000
Message-ID: <47CEF8C4B26E8C44B22B028A650E0EA9317AAD52@DBDE01.ent.ti.com>
References: <201201120753.00667.oneukum@suse.de>
 <Pine.LNX.4.44L0.1201121037340.1384-100000@iolanthe.rowland.org>
 <20120112215014.GC5735@xanatos> <20120112215459.GA1161@kroah.com>
 <20120112222947.GD5735@xanatos> <20120112223513.GA2925@kroah.com>
 <20120113061144.GA30569@suse.cz>
 <47CEF8C4B26E8C44B22B028A650E0EA9317A6B8B@DBDE01.ent.ti.com>
 <4F1096E9.4020501@mvista.com>
In-Reply-To: <4F1096E9.4020501@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> On 01/13/2012 01:40 PM, Gupta, Ajay Kumar wrote:
> 
> > CPPI4.1 (Communication Port Programming Interface) is a TI specific
> DMA
> > controller used in multiple TI platform such as AM33x, DA8x, AM35x,
> TI81x.
> > The DMA engine is mainly used by musb controller on above platform.
> 
>     There are (at least out of tree) platforms using CPPI 4.1 for
> Ethernet.
> 
> > Earlier version of the driver was submitted by Sergei Shtylyov at [1]
> but
> > was not merged due to disagreement on the location of driver in
> kernel.
> 
>     To be precise, TI requested pulling out already queued (to
> arch/arm/common/)
> CPPI 4.1 driver from RMK's patch system without even notifying me. At
> least that
> was RMK's version...
> 
> > Refer the discussions at [1] for more details.
> 
> > [1] http://marc.info/?l=linux-usb&m=125087318308323
> 
>     Unfortunately, that's not all of the discussion of interest.
> 
> > The new implementation of the CPPI4.1 DMA slave driver will be in the
> > drivers/dma folder, complying to dmaengine framework.
> 
>     Has there been any work in this direction done yet?

Currently we are working on design flow and API details which will be posted
first for review.

Ajay
> 
> > It would involve changes in existing musb driver also for which
> current
> > plan is to maintain the compatibility of non-CPPI4.1 DMA in musb
> driver.
> 
>     I didn't quite understand this part...
> 
> > The task is planned to be spitted into below subtasks.
> 
> > (1) Post RFC on the API details, changes envisaged in musb driver and
> other
> > challenges
> 
>     First of all, I foresee changes in drivers/dma/ to cope with the
> entity in
> CPPI 4.1 called the queue manager (there's also buffer manager but it
> wasn't
> implemented on DA8xx, so I didn't design any API for it).
> 
> > (2) Implement and post RFC for the CPPI4.1 DMA driver and changes
> needed in
> > musb driver.
> 
> > Let me know if you have any thoughts/comments on this.
> 
> > Regards,
> > Ajay
> 
> WBR, Sergei

