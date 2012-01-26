Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2AZO7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:59:18 -0500
Received: from 8bytes.org ([88.198.83.132]:34409 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab2AZO7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:59:17 -0500
Date: Thu, 26 Jan 2012 15:59:16 +0100
From: "joro@8bytes.org" <joro@8bytes.org>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Message-ID: <20120126145915.GG6269@8bytes.org>
References: <20120124142521.GE6269@8bytes.org> <20120125.093932.783007031082378997.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125.093932.783007031082378997.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 08:39:32AM +0100, Hiroshi Doyu wrote:
> From: Hiroshi DOYU <hdoyu@nvidia.com>
> Date: Thu, 17 Nov 2011 07:31:31 +0200
> Subject: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
> 
> Tegra 30 IOMMU H/W, SMMU (System Memory Management Unit). This patch
> implements struct iommu_ops for SMMU for the upper IOMMU API.
> 
> This H/W module supports multiple virtual address spaces(domain x4),
> and manages 2 level H/W translation pagetable.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
>  arch/arm/mach-tegra/include/mach/smmu.h |   63 ++
>  drivers/iommu/Kconfig                   |   11 +
>  drivers/iommu/Makefile                  |    1 +
>  drivers/iommu/tegra-smmu.c              | 1034 +++++++++++++++++++++++++++++++
>  4 files changed, 1109 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-tegra/include/mach/smmu.h
>  create mode 100644 drivers/iommu/tegra-smmu.c

Removed 'default y' and applied to arm/tegra as well. Thanks.


	Joerg

