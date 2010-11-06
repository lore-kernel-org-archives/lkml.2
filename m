Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0KFAm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 20:42:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab0KFAm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 20:42:57 -0400
Date: Fri, 5 Nov 2010 22:40:12 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 2.6.37-rc1
Message-ID: <20101106004012.GA3647@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

    git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37

To receive the following updates:

Jan Kiszka (1):
      KVM: x86: Issue smp_call_function_many with preemption disabled

Marcelo Tosatti (1):
      KVM: MMU: fix rmap_remove on non present sptes

Michael S. Tsirkin (1):
      KVM: Write protect memory after slot swap

Scott Wood (4):
      PPC: KVM: Book E doesn't have __end_interrupts.
      KVM: PPC: e500: Call kvm_vcpu_uninit() before kvmppc_e500_tlb_uninit().
      KVM: PPC: BookE: fix sleep with interrupts disabled
      KVM: PPC: BookE: Load the lower half of MSR

Vasiliy Kulikov (2):
      KVM: PPC: fix information leak to userland
      KVM: x86: fix information leak to userland


 arch/powerpc/kernel/kvm.c           |    2 +-
 arch/powerpc/kvm/booke_interrupts.S |    2 +-
 arch/powerpc/kvm/e500.c             |    2 +-
 arch/powerpc/kvm/powerpc.c          |    1 +
 arch/powerpc/kvm/timing.c           |    2 --
 arch/x86/kvm/mmu.c                  |    9 +++++----
 arch/x86/kvm/x86.c                  |   16 ++++++++++++----
 7 files changed, 21 insertions(+), 13 deletions(-)


