Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab0G0QmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:42:01 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:57485
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728Ab0G0Ql5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:41:57 -0400
X-SpamScore: -9
X-BigFish: VPS-9(z21eRzzz1202hzzz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L686DI-02-LGI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] IOMMU updates for 2.6.36
Date: Tue, 27 Jul 2010 18:43:47 +0200
Message-ID: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit b37fa16e78d6f9790462b3181602a26b5af36260:
  Linus Torvalds (1):
        Linux 2.6.35-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/2.6.36

Joerg Roedel (2):
      x86/amd-iommu: Export cache-coherency capability
      Merge branches 'iommu-api/2.6.36' and 'amd-iommu/2.6.36' into iommu/2.6.36

Kulikov Vasiliy (1):
      x86/amd-iommu: Use for_each_pci_dev()

Tom Lyon (1):
      iommu-api: Extension to check for interrupt remapping

 arch/x86/kernel/amd_iommu.c |    8 ++++++--
 drivers/pci/intel-iommu.c   |    2 ++
 include/linux/iommu.h       |    1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

The changes are all minor. There is one cleanup patch, and two patches that
extend the capabilities exported by the IOMMU-API. Please pull.

	Joerg


