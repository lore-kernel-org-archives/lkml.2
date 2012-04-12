Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252Ab2DLNfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:35:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56682 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933154Ab2DLNfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:35:00 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Greg KH <greg@kroah.com>, "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: Paul Walmsley <paul@pwsan.com>, "V, Aneesh" <aneesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>
Subject: RE: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Thread-Topic: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Thread-Index: AQHNA78a9lhevdYvxk2HV7vF+jKLg5aWSLeAgAAEfgCAAD9ygIAAQRWAgACIIFA=
Date: Thu, 12 Apr 2012 13:34:15 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
 <20120412030044.GA26236@kroah.com> <4F867A95.9030104@ti.com>
 <20120412131045.GB31384@kroah.com>
In-Reply-To: <20120412131045.GB31384@kroah.com>
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

Hi Greg,

On Thu, Apr 12, 2012 at 18:40:45, Greg KH wrote:
> On Thu, Apr 12, 2012 at 12:17:49PM +0530, Santosh Shilimkar wrote:
> > I was hoping that we will have some thing like drivers/memory/*
> > but since it doesn't exist, we used drivers/misc.
> 
> Why not create it?  I have no objection to that, it makes it more
> obvious as to what this really is.

There is another memory controller used in a few TI SoCs,
namely GPMC [1], do you prefer having it too there.

As of now it is not a driver, platform code handles GPMC, a patch
series for converting it into a driver (but still residing in
platform folder) was sent a few days back [2,3].


Regards
Afzal

[1]
GPMC (General Purpose Memory Controller) in brief:
GPMC is an unified memory controller dedicated to interfacing external
memory devices like
 Asynchronous SRAM like memories and application specific integrated circuit devices.
 Asynchronous, synchronous, and page mode burst NOR flash devices NAND flash
 Pseudo-SRAM devices

GPMC has to be configured as required by timings of the connected
peripheral. It needs to be configured only initially. Once it is
configured it can be used to handle different protocols like NAND,
NOR. Various kinds of devices like ethernet, uart, usb, fpga etc
can work using GPMC interface. GPMC has a seperate additional
functionality of NAND handling

[2] https://lkml.org/lkml/2012/4/5/210
[3] https://lkml.org/lkml/2012/4/5/212


