Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2DEQkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:40:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab2DEQkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:40:09 -0400
Message-ID: <4F7DCAE0.6010605@redhat.com>
Date: Thu, 05 Apr 2012 19:40:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] KVM fixes for 3.4-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull a few fixes from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.4

A bunch of powerpc KVM fixes, a guest and a host RCU fix (unrelated),
and a small build fix.

----------------------------------------------------------------
Alexander Graf (3):
      KVM: PPC: Book3S: Compile fix for ppc32 in HIOR access code
      KVM: PPC: Save/Restore CR over vcpu_run
      KVM: PPC: Book3S: PR: Fix preemption

Avi Kivity (1):
      Merge tag 'powerpc-fixes' of git://github.com/paulusmack/linux
into new/master

Gleb Natapov (1):
      KVM: Resolve RCU vs. async page fault problem

Marcelo Tosatti (1):
      KVM: VMX: vmx_set_cr0 expects kvm->srcu locked

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Fix kvm_alloc_linear in case where no linears
exist
      KVM: PPC: Book3S HV: Save and restore CR in __kvmppc_vcore_entry

Sasikantha babu (1):
      KVM: PMU: Fix integer constant is too large warning in
kvm_pmu_set_msr()

-- 
error compiling committee.c: too many arguments to function

