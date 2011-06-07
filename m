Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1FGKHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:07:49 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:1974 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab1FGKHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:07:48 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eKzz1202hzz8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMF039-02-4NR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [git pull] AMD IOMMU fixes for 3.0-rc2
Date: Tue, 7 Jun 2011 12:06:56 +0200
Message-ID: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:

  Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes

Joerg Roedel (3):
      x86/amd-iommu: Fix 3 possible endless loops
      x86/amd-iommu: Use only per-device dma_ops
      x86/amd-iommu: Fix boot crash with hidden PCI devices

 arch/x86/kernel/amd_iommu.c      |   48 +++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/amd_iommu_init.c |    8 +++---
 2 files changed, 49 insertions(+), 7 deletions(-)

These patches fix serious issues which were discovered recently like a
boot-stall and a boot crash when a device has an alias which does not exist a
pci_dev. Please pull.

	Joerg


