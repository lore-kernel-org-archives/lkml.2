Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab1DKJcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:32:13 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:17264 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1DKJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:32:12 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJHEHJ-02-1FG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: [PATCH 0/2] AMD IOMMU Extended feature base support
Date: Mon, 11 Apr 2011 11:32:02 +0200
Message-ID: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series implements detection of extended features of the AMD IOMMU.
It also implements the first feature, the INVALIDATE_ALL command to
flush the IOMMU caches right after enablement.

Regards,

	Joerg

Diffstat:

 arch/x86/include/asm/amd_iommu_proto.h |    8 ++++++++
 arch/x86/include/asm/amd_iommu_types.h |   18 ++++++++++++++++++
 arch/x86/kernel/amd_iommu.c            |   26 +++++++++++++++++++++++---
 arch/x86/kernel/amd_iommu_init.c       |   26 +++++++++++++++++++++++---
 4 files changed, 72 insertions(+), 6 deletions(-)

Shortlog:

Joerg Roedel (2):
      x86/amd-iommu: Add extended feature detection
      x86/amd-iommu: Add support for invalidate_all command


