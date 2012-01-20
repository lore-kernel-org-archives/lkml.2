Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2ATQHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:07:06 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:30942
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754008Ab2ATQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:07:03 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bh8275dhz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY3U3H-02-H5H-02
X-M-MSG: 
Date: Fri, 20 Jan 2012 17:05:52 +0100
From: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "b08248@gmail.com" <b08248@gmail.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>
Subject: Re: [PATCH 0/5] IOMMU: Make IOMMU-API ready for GART-like hardware
Message-ID: <20120120160552.GH2205@amd.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
 <20120120.081403.2268989617582455160.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120120.081403.2268989617582455160.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 20, 2012 at 07:14:03AM +0100, Hiroshi Doyu wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
> Subject: [PATCH 0/5] IOMMU: Make IOMMU-API ready for GART-like hardware
> Date: Thu, 19 Jan 2012 15:30:00 +0100
> Message-ID: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
> 
> > Hi,
> > 
> > this patch-set adds two new functions the the IOMMU-API:
> > 
> > 	* iommu_domain_set_attr()
> > 	* iommu_domain_get_attr()
> > 
> > These are generic functions to set and change attributes of a domain.
> > The plan is to have a set of generic attributes implemented by more than
> > one IOMMU driver as well as driver specific ones. As an example for the
> > first type this patch-set also implements the DOMAIN_ATTR_GEOMETRY
> > attribute. It can be used to query information about the address space
> > window that can be remapped by the iommu hardware. With this attribute
> > is is very easy to support IOMMUs like GART and friends.
> 
> For Tegra GART & SMMU, this info is passed from board files as
> resource data via "platform_get_resource(,IORESOURCE_MEM,)". I think
> that this could be the attachement patch in Tegra case. The attached
> patches are based on the following post.
> 
> https://lkml.org/lkml/2012/1/5/26
> https://lkml.org/lkml/2012/1/5/27

I will start merging new patches next week. These patches are on my
list. Once we have settled on a version of the patches in this thread I
also apply your posted addtion.


	Joerg



-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

