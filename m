Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab2GKKt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:49:28 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:53199
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085Ab2GKKt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:49:26 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M6ZSQA-01-0GW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] Make IOMMU-API ready for GART-like hardware
Date: Wed, 11 Jul 2012 12:49:16 +0200
Message-ID: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is finally a new version of this patch-set. Changes to the previous
version include:

	* Rebased to v3.5-rc6
	* Added missing Acked-by's

The potential issue with type-safety still exists. But since people are
desperatly waiting for the functionality of this patch-set I think we
live with it for now. If it turns out to be a real problem we can change
it any time.
Unless any major objections come up I plan to queue these patches for
v3.6.

Regards,

	Joerg

Diffstat:

 drivers/iommu/amd_iommu.c    |    4 ++++
 drivers/iommu/exynos-iommu.c |    4 ++++
 drivers/iommu/intel-iommu.c  |    4 ++++
 drivers/iommu/iommu.c        |   33 +++++++++++++++++++++++++++++++++
 drivers/iommu/msm_iommu.c    |    5 +++++
 drivers/iommu/omap-iommu.c   |    4 ++++
 drivers/iommu/tegra-gart.c   |    5 +++++
 drivers/iommu/tegra-smmu.c   |    5 +++++
 include/linux/iommu.h        |   36 +++++++++++++++++++++++++++++++++++-

 9 files changed, 99 insertions(+), 1 deletion(-)

