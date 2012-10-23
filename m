Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2JWRD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:03:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab2JWRDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:03:54 -0400
Message-ID: <5086CDF5.3020901@redhat.com>
Date: Tue, 23 Oct 2012 19:03:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 3.7-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull a few KVM fixes from the repo and tag at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.7-2

Fixing an oops, IPI misrouting in x2apic mode, and not exiting RCU
idle state when receiving an async page fault.

----------------------------------------------------------------
KVM updates for 3.7-rc2

----------------------------------------------------------------
Gleb Natapov (1):
      KVM: apic: fix LDR calculation in x2apic mode

Sasha Levin (1):
      KVM guest: exit idleness when handling KVM_PV_REASON_PAGE_NOT_PRESENT

Xiao Guangrong (1):
      KVM: MMU: fix release noslot pfn

 arch/x86/kernel/kvm.c | 3 +++
 arch/x86/kvm/lapic.c  | 2 +-
 arch/x86/kvm/mmu.c    | 3 +--
 virt/kvm/kvm_main.c   | 4 +---
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
error compiling committee.c: too many arguments to function
