Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1K2Run (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:50:43 -0500
Received: from bay0-omc1-s16.bay0.hotmail.com ([65.54.190.27]:36891 "EHLO
	bay0-omc1-s16.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab1K2Rum convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:50:42 -0500
Message-ID: <BAY163-W63C79C972B0F87A46B0FDCFBB30@phx.gbl>
X-Originating-IP: [82.43.252.147]
From: Anand Kanaginhal <anand_dk@hotmail.com>
To: <greg@kroah.com>
CC: Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: RE: PCIe Hotplugging not working
Date: Tue, 29 Nov 2011 09:50:41 -0800
Importance: Normal
In-Reply-To: <20111129142214.GC14845@kroah.com>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>,<BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>,<20111129142214.GC14845@kroah.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Nov 2011 17:50:41.0464 (UTC) FILETIME=[693F3B80:01CCAEBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resending as earlier sends failed
> Date: Tue, 29 Nov 2011 23:22:14 +0900
> From: greg@kroah.com
> To: anand_dk@hotmail.com
> CC: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
> Subject: Re: PCIe Hotplugging not working
> 
> On Tue, Nov 29, 2011 at 03:56:12AM -0800, Anand Kanaginhal wrote:
> > 
> > 
> > I am trying to get PCIe endpoint hot - plugging working
> > 
>
 > The Set up is such that there is one endpoint (our custom device) 
connected to PCI  switch PLX 8609 8 port 8 lane switch. 
> > 1. I have my driver module compiled, copied into /lib/modules/`uname -r`/kernel/drivers/char/
> 
> Why is a pci driver a "char" driver?  Do you have a pointer to the
> source of this?

I
 am doing an test before putting it in its right place. Another reason 
is that I am treating it as character device and using IOCTLs for 
various operations.
I have attached the framework code here.

> > 2. I run depmod and "modules.pcimap" also got updated with my module. 
> > 
> > However
> >  if I unplug and plug in the endpoint, my driver .probe and .remove functions
> >  are not being invoked. Is there something more to be done at the bus 
> > level to get the driver to hot plug ?
> 
> You need a pci hotplug controller driver, is that loaded?  That is what
> is responsible for eventually calling your remove function.

How do I figure out if a pci hotplug controller driver is installed? 


> > I have tried various kernel version, Currently I am trying on 2.6.38.12 (UBUNTU flavor).
> 
> We can't help you with distro-specific kernels, please use a kernel.org
> kernel and we will be glad to help you out.

I have tried with vanilla kernel as well with the same results.

> greg k-h

Thanks
Anand 		 	   		  