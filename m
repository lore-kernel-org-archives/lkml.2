Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab0GAOA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:00:26 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:25355
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756083Ab0GAOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:00:23 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz1dbaL4015Lzz1202hzzz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L4VTKB-01-9QE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Use u64 for gfn_t in KVM
Date: Thu, 1 Jul 2010 16:00:10 +0200
Message-ID: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Avi, Marcelo,

these two patches currently lie on the bottom of my npt-npt patch set. They
came out of a discussion on the mailing list about the last version of the
npt-npt patchset. These patches are independent of the rest of the patchset, so
I post and discuss them seperatly. The changes to make gfn_t an u64 were
larger than I expected which is another reason for the seperate post. Please
let me know what you think about this change.

Thanks,

	Joerg

Diffstat:

 arch/ia64/include/asm/kvm_host.h    |    1 +
 arch/powerpc/include/asm/kvm_host.h |    1 +
 arch/s390/include/asm/kvm_host.h    |    3 ++-
 arch/x86/include/asm/kvm_host.h     |    3 ++-
 arch/x86/kvm/mmu.c                  |    8 ++++----
 include/linux/kvm_types.h           |    4 ++--
 virt/kvm/iommu.c                    |    2 +-
 virt/kvm/kvm_main.c                 |   10 +++++-----
 8 files changed, 18 insertions(+), 14 deletions(-)

Shortlog:

Joerg Roedel (2):
      KVM: Remove unnecessary divide operations
      KVM: Use u64 for frame data types


