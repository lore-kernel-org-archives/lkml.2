Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0IWOor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:44:47 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:1739 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab0IWOoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:44:44 -0400
X-SpamScore: -13
X-BigFish: VS-13(z21eRz4015Lzz1202hzz8275dhz32i2a8h87h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L97FM9-01-70Q-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] AMD IOMMU fixes for 2.6.36
Date: Thu, 23 Sep 2010 16:44:46 +0200
Message-ID: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 49553c2ef88749dd502687f4eb9c258bb10a4f44:
  Linus Torvalds (1):
        Linux 2.6.36-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.36

Joerg Roedel (3):
      x86/amd-iommu: Set iommu configuration flags in enable-loop
      x86/amd-iommu: Work around S3 BIOS bug
      x86/amd-iommu: Fix rounding-bug in __unmap_single

 arch/x86/include/asm/amd_iommu_proto.h |    6 +++
 arch/x86/include/asm/amd_iommu_types.h |   12 ++++++
 arch/x86/kernel/amd_iommu.c            |    4 +-
 arch/x86/kernel/amd_iommu_init.c       |   67 +++++++++++++++++++++----------
 include/linux/pci_ids.h                |    3 +
 5 files changed, 69 insertions(+), 23 deletions(-)

The first two patches make resume from memory working with the AMD IOMMU driver
(one fixes a problem in the driver and the other works around a BIOS bug). The
third patch fixes a long standing rounding bug in the driver which may lead to
stale io/tlb entries. Please pull.

Thanks,
	Joerg


