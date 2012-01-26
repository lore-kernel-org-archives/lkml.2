Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2AZSlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:41:25 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:31194 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2AZSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:41:10 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzz8275dhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYF58G-01-7ND-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: [PATCH 0/6 v2] IOMMU: Make IOMMU-API ready for GART-like hardware
Date: Thu, 26 Jan 2012 19:40:51 +0100
Message-ID: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the second version of this patch-set. For a full description
please see the first post:

	https://lkml.org/lkml/2012/1/19/170

Changes from v1->v2:

	* Changed u64 to dma_addr_t as suggested by Laurent Pinchart
	* Moved description of new iommu_ops members to first patch
	* Added the necessary changes for the Tegra IOMMUs as posted by
	  Hiroshi Doyu

As always, any feedback is appreciated :-)

Thanks,

	Joerg

Diffstat:

 drivers/iommu/amd_iommu.c   |    4 ++++
 drivers/iommu/intel-iommu.c |    4 ++++
 drivers/iommu/iommu.c       |   33 +++++++++++++++++++++++++++++++++
 drivers/iommu/msm_iommu.c   |    5 +++++
 drivers/iommu/omap-iommu.c  |    4 ++++
 drivers/iommu/tegra-gart.c  |    5 +++++
 drivers/iommu/tegra-smmu.c  |    5 +++++
 include/linux/iommu.h       |   36 +++++++++++++++++++++++++++++++++++-
 8 files changed, 95 insertions(+), 1 deletions(-)


