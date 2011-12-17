Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab1LQBPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 20:15:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16061 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1LQBPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 20:15:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 16 Dec 2011 17:15:14 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
CC: "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Date: Sat, 17 Dec 2011 02:15:09 +0100
Subject: Re: [PATCH v2 1/2] [RFC] ARM: IOMMU: Tegra20: iommu_ops for GART
 driver
Thread-Topic: [PATCH v2 1/2] [RFC] ARM: IOMMU: Tegra20: iommu_ops for GART
 driver
Thread-Index: Acy8WVIEfp1cy2DESoaU+9P3XPDk0g==
Message-ID: <20111217.031509.550537371548178833.hdoyu@nvidia.com>
References: <1323954690-7000-1-git-send-email-hdoyu@nvidia.com><1323954690-7000-2-git-send-email-hdoyu@nvidia.com><20111216154331.GD29877@amd.com>
In-Reply-To: <20111216154331.GD29877@amd.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg, Thank you for your quick review.

From: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH v2 1/2] [RFC] ARM: IOMMU: Tegra20: iommu_ops for GART driver
Date: Fri, 16 Dec 2011 16:43:31 +0100
Message-ID: <20111216154331.GD29877@amd.com>

> On Thu, Dec 15, 2011 at 03:11:29PM +0200, Hiroshi DOYU wrote:
> > Tegra 20 IOMMU H/W, GART (Graphics Address Relocation Table). This
> > patch implements struct iommu_ops for GART for the upper IOMMU API.
> > 
> > This H/W module supports only single virtual address space(domain),
> > and manages a single level 1-to-1 mapping H/W translation page table.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> > ---
> >  drivers/iommu/Kconfig      |   11 +
> >  drivers/iommu/Makefile     |    1 +
> >  drivers/iommu/tegra-gart.c |  451 ++++++++++++++++++++++++++++++++++++++++++++
> 
> The code looks good in general.

Thanks.

> I think we need to extend the IOMMU-API
> a little bit to better support GART IOMMUs. A user of the IOMMU-API
> should be able to get the information about the iova-base and size of
> the aperture for example. These extensions will be beneficial for
> porting other GART-like driver to the IOMMU-API too.

is it similar to how ".pgsize_bitmap" is passed?

> 
> 
> 	Joerg
> 
> -- 
> AMD Operating System Research Center
> 
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632
> 
