Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1LVOBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:01:33 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:22530
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab1LVOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:01:30 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWLYYC-02-239-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [Patch 0/3] Pending AMD IOMMU patches
Date: Thu, 22 Dec 2011 15:01:16 +0100
Message-ID: <1324562479-29755-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are 3 pending patches from my AMD IOMMU queue. No real bug-fixes in
there.  The patches just increase consistency and robustnes of the AMD
IOMMU driver.


	Joerg

Diffstat:

 drivers/iommu/amd_iommu.c       |    2 ++
 drivers/iommu/amd_iommu_init.c  |   20 +++++++++++++-------
 drivers/iommu/amd_iommu_types.h |   10 ++++++++++
 3 files changed, 25 insertions(+), 7 deletions(-)


