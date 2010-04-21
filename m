Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0DULAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 07:00:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0DULAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 07:00:03 -0400
Message-ID: <4BCEDAA8.5000608@redhat.com>
Date: Wed, 21 Apr 2010 13:59:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 2.6.34-rc5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull a bunch of kvm fixes from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.34

Shortlog/diffstat follow.

Andre Przywara (1):
       KVM: allow bit 10 to be cleared in MSR_IA32_MC4_CTL

Avi Kivity (2):
       KVM: Don't spam kernel log when injecting exceptions due to bad 
cr writes
       KVM: VMX: Save/restore rflags.vm correctly in real mode

Gleb Natapov (1):
       KVM: take srcu lock before call to complete_pio()

Jan Kiszka (1):
       KVM: x86: Fix TSS size check for 16-bit tasks

Lai Jiangshan (1):
       KVM: Add missing srcu_read_lock() for kvm_mmu_notifier_release()

Sridhar Samudrala (1):
       KVM: Increase NR_IOBUS_DEVS limit to 200

Takuya Yoshikawa (2):
       KVM: SVM: Fix memory leaks that happen when svm_create_vcpu() fails
       KVM: fix the handling of dirty bitmaps to avoid overflows

Xiao Guangrong (1):
       KVM: MMU: fix kvm_mmu_zap_page() and its calling path

  arch/ia64/kvm/kvm-ia64.c  |    9 ++++---
  arch/powerpc/kvm/book3s.c |    5 ++-
  arch/x86/kvm/mmu.c        |   11 ++++++---
  arch/x86/kvm/svm.c        |   25 ++++++++++++++---------
  arch/x86/kvm/vmx.c        |   24 ++++++++++++++--------
  arch/x86/kvm/x86.c        |   48 
+++++++++++++++------------------------------
  include/linux/kvm_host.h  |    7 +++++-
  virt/kvm/kvm_main.c       |   17 +++++++++++----
  8 files changed, 79 insertions(+), 67 deletions(-)

-- 
error compiling committee.c: too many arguments to function

