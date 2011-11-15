Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1KOPuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:50:13 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:59645
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756434Ab1KOPuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:50:10 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LUPLBD-01-78N-02
X-M-MSG: 
Date: Tue, 15 Nov 2011 16:49:54 +0100
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <iommu@lists.linux-foundation.org>, <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>
Subject: Re: [PATCH v4-rebased 0/7] iommu: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111115154954.GD5627@amd.com>
References: <1320917551-11328-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320917551-11328-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 11:32:24AM +0200, Ohad Ben-Cohen wrote:
> Ohad Ben-Cohen (7):
>   iommu/core: stop converting bytes to page order back and forth
>   iommu/core: split mapping to page sizes as supported by the hardware
>   iommu/omap: announce supported page sizes
>   iommu/msm: announce supported page sizes
>   iommu/amd: announce supported page sizes
>   iommu/intel: announce supported page sizes
>   iommu/core: remove the temporary pgsize settings
> 
>  drivers/iommu/amd_iommu.c   |   32 +++++++++---
>  drivers/iommu/intel-iommu.c |   30 ++++++++---
>  drivers/iommu/iommu.c       |  119 ++++++++++++++++++++++++++++++++++++++----
>  drivers/iommu/msm_iommu.c   |   25 ++++-----
>  drivers/iommu/omap-iommu.c  |   18 +++---
>  drivers/iommu/omap-iovmm.c  |   17 ++----
>  include/linux/iommu.h       |   26 +++++++--
>  virt/kvm/iommu.c            |    8 ++--
>  8 files changed, 205 insertions(+), 70 deletions(-)

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

