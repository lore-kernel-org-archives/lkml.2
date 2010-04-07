Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab0DGMsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:48:54 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:27035
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932588Ab0DGMso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:44 -0400
X-SpamScore: -18
X-BigFish: VPS-18(z21eWz4015Lzz1202hzzz32i87h2a8h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJS-01-9UN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL][PATCH 0/12] IOMMU fixes for 2.6.34-rc3
Date: Wed, 7 Apr 2010 14:46:37 +0200
Message-ID: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 07 Apr 2010 12:46:55.0758 (UTC) FILETIME=[679D72E0:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6:
  Linus Torvalds (1):
        Linux 2.6.34-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes

Chris Wright (5):
      x86/amd-iommu: Pt mode fix for domain_destroy
      x86/amd-iommu: enable iommu before attaching devices
      x86/amd-iommu: warn when issuing command to uninitialized cmd buffer
      Revert "x86: disable IOMMUs on kernel crash"
      x86/amd-iommu: use for_each_pci_dev

Dan Carpenter (1):
      dma-debug: Cleanup for copy-loop in filter_write()

Joerg Roedel (6):
      x86/amd-iommu: Protect IOMMU-API map/unmap path
      x86/amd-iommu: Report errors in acpi parsing functions upstream
      x86/amd-iommu: Use helper function to destroy domain
      x86/amd-iommu: Remove obsolete parameter documentation
      Merge branch 'amd-iommu/fixes' into iommu/fixes
      x86/gart: Disable GART explicitly before initialization

Julia Lawall (1):
      x86/amd-iommu: Remove double NULL check in check_device

 Documentation/kernel-parameters.txt    |    5 ---
 arch/x86/include/asm/amd_iommu_types.h |    3 ++
 arch/x86/kernel/amd_iommu.c            |   20 +++++++++----
 arch/x86/kernel/amd_iommu_init.c       |   48 ++++++++++++++++++++++----------
 arch/x86/kernel/aperture_64.c          |   15 +++++++++-
 arch/x86/kernel/crash.c                |    6 ----
 arch/x86/kernel/pci-gart_64.c          |    3 ++
 lib/dma-debug.c                        |    2 +-
 8 files changed, 68 insertions(+), 34 deletions(-)

This pull request includes fixes that did not made it upstream during the merge
window, fixes for recently discovered problems with kdump and amd-iommu
enabled and a small documentation update. Please pull.

Thanks,

	Joerg


