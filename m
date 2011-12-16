Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab1LPPnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:43:49 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:27949
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759758Ab1LPPnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:43:43 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWAZOO-01-44P-02
X-M-MSG: 
Date: Fri, 16 Dec 2011 16:43:31 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] [RFC] ARM: IOMMU: Tegra20: iommu_ops for GART
 driver
Message-ID: <20111216154331.GD29877@amd.com>
References: <1323954690-7000-1-git-send-email-hdoyu@nvidia.com>
 <1323954690-7000-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323954690-7000-2-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 03:11:29PM +0200, Hiroshi DOYU wrote:
> Tegra 20 IOMMU H/W, GART (Graphics Address Relocation Table). This
> patch implements struct iommu_ops for GART for the upper IOMMU API.
> 
> This H/W module supports only single virtual address space(domain),
> and manages a single level 1-to-1 mapping H/W translation page table.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
>  drivers/iommu/Kconfig      |   11 +
>  drivers/iommu/Makefile     |    1 +
>  drivers/iommu/tegra-gart.c |  451 ++++++++++++++++++++++++++++++++++++++++++++

The code looks good in general. I think we need to extend the IOMMU-API
a little bit to better support GART IOMMUs. A user of the IOMMU-API
should be able to get the information about the iova-base and size of
the aperture for example. These extensions will be beneficial for
porting other GART-like driver to the IOMMU-API too.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

