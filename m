Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab2HWHaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab2HWHal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:30:41 -0400
Date: Thu, 23 Aug 2012 04:30:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.6-rc3
Message-ID: <20120823073004.GA22074@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following KVM bug fixes:


Alan Cox (1):
      ppc: e500_tlb memset clears nothing

Alexander Graf (1):
      KVM: PPC: Add cache flush on page map

Avi Kivity (1):
      KVM: x86 emulator: use stack size attribute to mask rsp in stack ops

Gleb Natapov (1):
      KVM: x86: update KVM_SAVE_MSRS_BEGIN to correct value

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix incorrect branch in H_CEDE code

Takuya Yoshikawa (1):
      KVM: MMU: Fix mmu_shrink() so that it can free mmu pages as intended


 arch/powerpc/include/asm/kvm_host.h     |    1 +
 arch/powerpc/include/asm/kvm_ppc.h      |   12 ++++++++++++
 arch/powerpc/kvm/book3s_32_mmu_host.c   |    3 +++
 arch/powerpc/kvm/book3s_64_mmu_host.c   |    2 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   12 +++++++-----
 arch/powerpc/kvm/e500_tlb.c             |   11 +++++++----
 arch/powerpc/mm/mem.c                   |    1 +
 arch/x86/kvm/emulate.c                  |   30 +++++++++++++++++++++---------
 arch/x86/kvm/mmu.c                      |   13 +++++++++----
 arch/x86/kvm/x86.c                      |    2 +-
 10 files changed, 64 insertions(+), 23 deletions(-)
