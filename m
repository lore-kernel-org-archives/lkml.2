Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab0EMUOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:14:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab0EMUOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:14:51 -0400
Date: Thu, 13 May 2010 15:53:26 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for 2.6.34-rc7
Message-ID: <20100513185326.GA22734@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.34

To receive the following updates:

Dongxiao Xu (1):
      KVM: x86: Call vcpu_load and vcpu_put in cpuid_update

Jan Kiszka (1):
      KVM: VMX: blocked-by-sti must not defer NMI injections

Joerg Roedel (1):
      KVM: SVM: Fix wrong intercept masks on 32 bit

Marcelo Tosatti (1):
      KVM: convert ioapic lock to spinlock

Roel Kluin (1):
      KVM: PPC: Keep index within boundaries in kvmppc_44x_emul_tlbwe()


 arch/powerpc/kvm/44x_tlb.c |    2 +-
 arch/x86/kvm/svm.c         |    8 ++++----
 arch/x86/kvm/vmx.c         |    3 +--
 arch/x86/kvm/x86.c         |    4 ++++
 virt/kvm/ioapic.c          |   30 +++++++++++++++---------------
 virt/kvm/ioapic.h          |    2 +-
 6 files changed, 26 insertions(+), 23 deletions(-)

