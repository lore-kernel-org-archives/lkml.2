Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab2EKMnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:43:35 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:25733
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318Ab2EKMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:43:34 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bh8275dhz2dh668h839h944hd25he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3UZCC-02-9C4-02
X-M-MSG: 
Date: Fri, 11 May 2012 14:43:27 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: KyongHo <pullip.cho@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>
Subject: Re: [PATCH] iommu/exynos: Add iommu driver for Exynos Platforms
Message-ID: <20120511124327.GB11750@amd.com>
References: <000001cd2f71$62c5c2f0$285148d0$%cho@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <000001cd2f71$62c5c2f0$285148d0$%cho@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 09:27:09PM +0900, KyongHo wrote:
> This is the System MMU driver and IOMMU API implementation for Exynos SOC
> platforms. Exynos platforms has more than 10 System MMUs dedicated for each
> multimedia accelerators.
> 
> The System MMU driver is already in arc/arm/plat-s5p but it is moved to
> drivers/iommu due to Ohad Ben-Cohen gathered IOMMU drivers there
> 
> Any device driver in Exynos platforms that needs to control its System MMU must
> call platform_set_sysmmu() to inform System MMU driver who will control it.
> platform_set_sysmmu() is defined in <mach/sysmmu.h>
> 
> To compile this patch,
> you will need "for-next" branch of the linux-samsung.git:
> git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> Other patches needed by this patch are merged to the above branch.
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>

Looks good.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

Please get this merged via the Samsung tree. Since the patch depends on
that tree anyway it makes the most sense to be there.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

