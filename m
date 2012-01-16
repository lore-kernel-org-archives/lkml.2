Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2APK7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:59:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51700 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2APK7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:59:39 -0500
From: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>, "Balbi, Felipe" <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
Thread-Topic: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
Thread-Index: AQHM0bzZ3HvTVi65q0q5jVepkBzZG5YKErvggABU+ID///dXgIABpvOAgALRbJA=
Date: Mon, 16 Jan 2012 10:59:34 +0000
Message-ID: <47CEF8C4B26E8C44B22B028A650E0EA9317AAD89@DBDE01.ent.ti.com>
References: <201201120753.00667.oneukum@suse.de>
 <Pine.LNX.4.44L0.1201121037340.1384-100000@iolanthe.rowland.org>
 <20120112215014.GC5735@xanatos> <20120112215459.GA1161@kroah.com>
 <20120112222947.GD5735@xanatos> <20120112223513.GA2925@kroah.com>
 <20120113061144.GA30569@suse.cz>
 <47CEF8C4B26E8C44B22B028A650E0EA9317A6B8B@DBDE01.ent.ti.com>
 <4F1096E9.4020501@mvista.com>
 <20120113201010.GJ3133@legolas.emea.dhcp.ti.com> <4F11F271.402@mvista.com>
In-Reply-To: <4F11F271.402@mvista.com>
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

> On 14-01-2012 0:10, Felipe Balbi wrote:
> 
> >>> CPPI4.1 (Communication Port Programming Interface) is a TI specific
> DMA
> >>> controller used in multiple TI platform such as AM33x, DA8x, AM35x,
> TI81x.
> >>> The DMA engine is mainly used by musb controller on above platform.
> 
> >>     There are (at least out of tree) platforms using CPPI 4.1 for
> Ethernet.
> 
> > if they are out of tree, I'm sorry but we don't care about them. If
> they
> > are in tree, then that needs to be sorted out on the same patchset.
> 
>     I'm not sure if Puma-5 is the only one using CPPI 4.1 for Etherhet,
> and not some new platfroms introduced just now like AM33x/TI81x.

Currently AM33x/TI81x doesn't use cppi4.1 for Ethernet.

> 
> >>> It would involve changes in existing musb driver also for which
> current
> >>> plan is to maintain the compatibility of non-CPPI4.1 DMA in musb
> driver.
> 
> >>     I didn't quite understand this part...
> 
> > how come ? What he's saying is that while moving cppi-dma.c to
> 
>     How come we are taling of cppi-dma.c at all? It's CPPI 3.0 driver
> having
> nothing in common with CPPI 4.1.
> 
> > drivers/dma he will not move all the other dma engines (Inventra,
> OMAP,
> > TUSB-over-GPMC, etc).
> 
> >>> The task is planned to be spitted into below subtasks.
> 
> >>> (1) Post RFC on the API details, changes envisaged in musb driver
> and other
> >>> challenges
> 
> >>     First of all, I foresee changes in drivers/dma/ to cope with the
> >> entity in CPPI 4.1 called the queue manager (there's also buffer
> >> manager but it wasn't implemented on DA8xx, so I didn't design any
> >> API for it).
> 
> > that's why the kernel is open source, right ? If we need to improve
> the
> > framework so that it understands other types of DMAs, so be it.
> 
>     I just foresee difficulties here. 

We can discuss more on this when we post design and API flow for review.

Regards,
Ajay
> 
> WBR, Sergei
