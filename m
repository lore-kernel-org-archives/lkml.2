Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2EILDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:03:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711Ab2EILDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:03:03 -0400
Message-ID: <4FAA4EE4.3080304@redhat.com>
Date: Wed, 09 May 2012 14:03:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 3.4-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

for you to fetch changes up to 331b646d60b0c3885208e1e02bd9f40319953efc:

  KVM: ia64: fix build due to typo (2012-05-09 13:53:28 +0300)

Two asynchronous page fault fixes (one guest, one host), a powerpc page
refcount fix, and an ia64 build fix.

----------------------------------------------------------------
Avi Kivity (1):
      KVM: ia64: fix build due to typo

David Gibson (1):
      KVM: PPC: Book3S HV: Fix refcounting of hugepages

Gleb Natapov (2):
      KVM: ensure async PF event wakes up vcpu from halt
      KVM: Do not take reference to mm during async #PF

 arch/ia64/kvm/kvm-ia64.c            |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   22 +++++++++++++---------
 arch/powerpc/kvm/book3s_hv.c        |    2 --
 arch/x86/kernel/kvm.c               |    9 +--------
 arch/x86/kvm/x86.c                  |    1 +
 5 files changed, 16 insertions(+), 20 deletions(-)

-- 
error compiling committee.c: too many arguments to function

