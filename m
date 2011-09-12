Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1ILLkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 07:40:21 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26092 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab1ILLkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 07:40:15 -0400
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>, Greg KH <gregkh@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Thread-Topic: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Thread-Index: AQHMbgNnEHbH2ksOTkK6XUaJZsZynZVJpGbg
Date: Mon, 12 Sep 2011 11:40:10 +0000
Message-ID: <F1FD01C1EFCE15408DBF59462450B3BD1C461D@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de> <20110907191919.GA31674@8bytes.org>
 <20110907194445.GA2526@suse.de> <20110908084154.GC31674@8bytes.org>
In-Reply-To: <20110908084154.GC31674@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf Of Joerg Roedel
> Sent: Thursday, September 08, 2011 2:12 PM
> To: Greg KH
> Cc: Joerg Roedel; iommu@lists.linux-foundation.org; Alex Williamson; Ohad
> Ben-Cohen; David Woodhouse; David Brown; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
> 
> On Wed, Sep 07, 2011 at 12:44:45PM -0700, Greg KH wrote:
> > On Wed, Sep 07, 2011 at 09:19:19PM +0200, Joerg Roedel wrote:
> > > Hi Greg,
> > >
> > > the bus_set_iommu() function will be called by the IOMMU driver.
> > > There can be different drivers for the same bus, depending on the
> > > hardware. On PCI for example, there can be the Intel or the AMD
> > > IOMMU driver that implement the iommu-api and that register for that
> bus.
> >
> > Why are you pushing this down into the driver core?  What other busses
> > becides PCI use/need this?
> 
> Currently it is the platform_bus besides pci. The pci iommus are on x86
> and ia64 while all arm iommus use the platform_bus (by 'iommus' I only
> mean those implementing the iommu-api). Currently there are two drivers
> for arm iommus in /drivers/iommu.
> 
We too have an IOMMU on Freescale Socs (Power core based) sitting on the platform bus
and are looking at integrating it with the linux IOMMU API.

-Varun

