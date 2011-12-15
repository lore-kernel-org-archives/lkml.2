Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab1LOKXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:23:34 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:16452 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1LOKXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:23:33 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LW8Q73-02-EHD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Additional AMD IOMMUv2 patches
Date: Thu, 15 Dec 2011 11:23:19 +0100
Message-ID: <1323944602-26155-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are 3 additional patches I have in my queue for the AMD IOMMUv2 driver.
The patches extend the exposed API a little bit and fix the build error in
linux-next.

Regards,

	Joerg

Diffstat:

 drivers/iommu/amd_iommu.c    |   59 ++++++++++++++++++++++++++++++++++++-----
 drivers/iommu/amd_iommu_v2.c |   35 +++++++++++++++++++++++++
 include/linux/amd-iommu.h    |   43 ++++++++++++++++++++++++++++++
 3 files changed, 129 insertions(+), 8 deletions(-)


