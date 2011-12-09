Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1LIXYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:24:04 -0500
Received: from bay0-omc1-s28.bay0.hotmail.com ([65.54.190.39]:11157 "EHLO
	bay0-omc1-s28.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab1LIXYB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:24:01 -0500
Message-ID: <BAY163-W61A8DF92159F5C3E26103FBB90@phx.gbl>
X-Originating-IP: [82.43.252.178]
From: Anand Kanaginhal <anand_dk@hotmail.com>
To: <greg@kroah.com>
CC: <mjg59@srcf.ucam.org>, <bhelgaas@google.com>,
        Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: RE: PCIe Hotplugging not working
Date: Fri, 9 Dec 2011 15:24:00 -0800
Importance: Normal
In-Reply-To: <BAY163-W582FC4C5828B20E9487D3EFBB90@phx.gbl>
References: <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>,<20111130154022.GA1411@srcf.ucam.org>,<BAY163-W80F10350D24162EFC3699FBB00@phx.gbl>,<20111130182423.GA4831@srcf.ucam.org>,<CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>,<BAY163-W600D6D6A04D4BAE8278907FBB90@phx.gbl>,<20111209124524.GA3488@srcf.ucam.org>,<BAY163-W45C53B9E3E9E0B8629B683FBB90@phx.gbl>,<20111209180708.GA10768@kroah.com>,<BAY163-W154A24444BB398F609767CFBB90@phx.gbl>,<20111209222520.GA24786@kroah.com>,<BAY163-W582FC4C5828B20E9487D3EFBB90@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Dec 2011 23:24:00.0987 (UTC) FILETIME=[A205C2B0:01CCB6C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the feedback again Greg, MY Comments inline

> Date: Fri, 9 Dec 2011 14:25:20 -0800
> From: greg@kroah.com
> To: anand_dk@hotmail.com
> CC: mjg59@srcf.ucam.org; bhelgaas@google.com; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
> Subject: Re: PCIe Hotplugging not working
> 
> On Fri, Dec 09, 2011 at 01:17:53PM -0800, Anand Kanaginhal wrote:
> > 
> > 
> > > Date: Fri, 9 Dec 2011 10:07:08 -0800
> > > From: greg@kroah.com
> > > To: anand_dk@hotmail.com
> > > CC: mjg59@srcf.ucam.org; bhelgaas@google.com; linux-pci@vger.kernel.org;
> > linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
> > > Subject: Re: PCIe Hotplugging not working
> > >
> > > On Fri, Dec 09, 2011 at 09:19:39AM -0800, Anand Kanaginhal wrote:
> > > > 1. With the above setup, If I hotplug card c1 and/or c2, will my driver
> > probe
> > > > get invoked.
> > >
> > > Stop right here. Please get your pci hotplug controller driver working
> > > first, for your platform. That seems to be the problem. After that,
> > > the rest of your questions should just resolve themselves.
> > Thank you Greg for your assistance, perhaps it would be little more helpful, if
> > you could tell me the basis on which you drew the conclusion. I am no kernel
> > expert :( 
> 
> As your driver's callbacks aren't being called, that's probably why this
> isn't working.
> 
Right that makes sense

> Please make sure your pci hotplug driver is working first.  Try turning
> on and off the power to the card slot (in the sysfs directory for the
> slot) and see if that's working.
When I do this, my driver probe and remove gets invoked. 

> You also have failed to say exactly what pci hotplug controller you have
> in your system, what is it?  You have to have one, and the driver loaded
> for it, for any of this to work at all.

We are using plx 8533 in our system, it hasnt provided controller driver for linux, however the support team insists that any hotplug controller driver which is compliant to PCI SIG, should work fine.My assumption was shpc in linux would work just fine. 

ThanksAnand
> greg k-h
 		 	   		   		 	   		  