Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab2DLOVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:21:31 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:44659 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934322Ab2DLOV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:21:29 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Mohammed\, Afzal" <afzal@ti.com>
Cc: Greg KH <greg@kroah.com>, "Shilimkar\, Santosh" <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, "V\, Aneesh" <aneesh@ti.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer\@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter\@redhat.com" <msalter@redhat.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Organization: Texas Instruments, Inc.
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
	<alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
	<20120412030044.GA26236@kroah.com> <4F867A95.9030104@ti.com>
	<20120412131045.GB31384@kroah.com>
	<C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
Date: Thu, 12 Apr 2012 07:21:18 -0700
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
	(Afzal Mohammed's message of "Thu, 12 Apr 2012 13:34:15 +0000")
Message-ID: <871untjajl.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Mohammed, Afzal" <afzal@ti.com> writes:

> Hi Greg,
>
> On Thu, Apr 12, 2012 at 18:40:45, Greg KH wrote:
>> On Thu, Apr 12, 2012 at 12:17:49PM +0530, Santosh Shilimkar wrote:
>> > I was hoping that we will have some thing like drivers/memory/*
>> > but since it doesn't exist, we used drivers/misc.
>> 
>> Why not create it?  I have no objection to that, it makes it more
>> obvious as to what this really is.
>
> There is another memory controller used in a few TI SoCs,
> namely GPMC [1], do you prefer having it too there.
>
> As of now it is not a driver, platform code handles GPMC, a patch
> series for converting it into a driver (but still residing in
> platform folder) was sent a few days back [2,3].

IMO, wherever EMIF ends up, GPMC should as well.

Kevin


> [1]
> GPMC (General Purpose Memory Controller) in brief:
> GPMC is an unified memory controller dedicated to interfacing external
> memory devices like
>  Asynchronous SRAM like memories and application specific integrated circuit devices.
>  Asynchronous, synchronous, and page mode burst NOR flash devices NAND flash
>  Pseudo-SRAM devices
>
> GPMC has to be configured as required by timings of the connected
> peripheral. It needs to be configured only initially. Once it is
> configured it can be used to handle different protocols like NAND,
> NOR. Various kinds of devices like ethernet, uart, usb, fpga etc
> can work using GPMC interface. GPMC has a seperate additional
> functionality of NAND handling
>
> [2] https://lkml.org/lkml/2012/4/5/210
> [3] https://lkml.org/lkml/2012/4/5/212
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
