Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab2I1MYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:24:14 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:25172
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012Ab2I1MYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzzz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27S6-02-8L4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/16] Interrupt remapping support for AMD IOMMU
Date: Fri, 28 Sep 2012 14:23:50 +0200
Message-ID: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a new version of the remaining patches to add interrupt
remapping support to the AMD IOMMU driver. The patches have been rebased
to v3.6-rc7 and tested again on various machines. As with the previous
version no issued were found with these patches too.

Regards,

	Joerg

Diffstat:

 drivers/iommu/Kconfig           |    2 +-
 drivers/iommu/amd_iommu.c       |  504 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_init.c  |  237 +++++++++++++++++-
 drivers/iommu/amd_iommu_proto.h |    8 +
 drivers/iommu/amd_iommu_types.h |   53 ++++
 drivers/iommu/irq_remapping.c   |    5 +
 drivers/iommu/irq_remapping.h   |    6 +
 7 files changed, 801 insertions(+), 14 deletions(-)


