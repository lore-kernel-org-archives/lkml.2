Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2APEZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 23:25:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38064 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab2APEZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 23:25:21 -0500
From: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
To: Greg KH <greg@kroah.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
Thread-Topic: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
Thread-Index: AQHM0bzZ3HvTVi65q0q5jVepkBzZG5YKErvggAAqlwCABCuSkA==
Date: Mon, 16 Jan 2012 04:25:15 +0000
Message-ID: <47CEF8C4B26E8C44B22B028A650E0EA9317AA069@DBDE01.ent.ti.com>
References: <201201120753.00667.oneukum@suse.de>
 <Pine.LNX.4.44L0.1201121037340.1384-100000@iolanthe.rowland.org>
 <20120112215014.GC5735@xanatos> <20120112215459.GA1161@kroah.com>
 <20120112222947.GD5735@xanatos> <20120112223513.GA2925@kroah.com>
 <20120113061144.GA30569@suse.cz>
 <47CEF8C4B26E8C44B22B028A650E0EA9317A6B8B@DBDE01.ent.ti.com>
 <20120113180932.GB29700@kroah.com>
In-Reply-To: <20120113180932.GB29700@kroah.com>
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
> On Fri, Jan 13, 2012 at 10:40:50AM +0000, Gupta, Ajay Kumar wrote:
> > Hi,
> >
> > CPPI4.1 (Communication Port Programming Interface) is a TI specific
> DMA
> > controller used in multiple TI platform such as AM33x, DA8x, AM35x,
> TI81x.
> > The DMA engine is mainly used by musb controller on above platform.
> >
> > Earlier version of the driver was submitted by Sergei Shtylyov at [1]
> but
> > was not merged due to disagreement on the location of driver in
> kernel.
> > Refer the discussions at [1] for more details.
> >
> > [1] http://marc.info/?l=linux-usb&m=125087318308323
> >
> > The new implementation of the CPPI4.1 DMA slave driver will be in the
> > drivers/dma folder, complying to dmaengine framework.
> > It would involve changes in existing musb driver also for which
> current
> > plan is to maintain the compatibility of non-CPPI4.1 DMA in musb
> driver.
> >
> > The task is planned to be spitted into below subtasks.
> >
> > (1) Post RFC on the API details, changes envisaged in musb driver and
> other
> > challenges
> >
> > (2) Implement and post RFC for the CPPI4.1 DMA driver and changes
> needed in
> > musb driver.
> >
> > Let me know if you have any thoughts/comments on this.
> 
> First off, don't highjack threads (you responded to a linux-usb thread
> here, get a better email client please.)

Sorry for inconvenience, I will take care of this in future.

Thanks,
Ajay
> 
> Second, that sounds fine, please post patches.
> 
> thanks,
> 
> greg k-h
