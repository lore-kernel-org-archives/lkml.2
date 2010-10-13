Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0JMMfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:35:37 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:30363
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092Ab0JMMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:35:36 -0400
X-SpamScore: -9
X-BigFish: VS-9(z21eRzzz1202hzz8275dhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LA8AYZ-02-SBP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD IOMMU updates for 2.6.37
Date: Wed, 13 Oct 2010 14:36:02 +0200
Message-ID: <1286973364-17077-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:
  Linus Torvalds (1):
        Linux 2.6.36-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.37

Joerg Roedel (1):
      x86/amd-iommu: Update copyright headers

Matthew Garrett (1):
      x86/amd-iommu: Reenable AMD IOMMU if it's mysteriously vanished over suspend

 arch/x86/include/asm/amd_iommu.h       |    2 +-
 arch/x86/include/asm/amd_iommu_proto.h |    2 +-
 arch/x86/include/asm/amd_iommu_types.h |   23 ++++--
 arch/x86/kernel/amd_iommu.c            |    2 +-
 arch/x86/kernel/amd_iommu_init.c       |  124 ++++++++++++++++++++++++++++----
 5 files changed, 128 insertions(+), 25 deletions(-)

This update is mostly about a workaround for BIOS problems with AMD IOMMU when
resuming from S3. The BIOS on an AMD IOMMU capable machine might be buggy so
that the IOMMU device is not re-enabled on resume. The patch from Matthew
implement a workaround for this problem by manually re-enabling an
re-programming the IOMMU device on resume. Please pull.

	Joerg
	

