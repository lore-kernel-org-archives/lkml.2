Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2BEKgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 05:36:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2BEKgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 05:36:35 -0500
Message-ID: <4F2E5BB0.7040702@redhat.com>
Date: Sun, 05 Feb 2012 12:36:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates for 3.3-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.3

Fixing a regression with the PMU MSRs when PMU virtualization is
disabled, a guest-internal DoS with the SYSCALL instruction, and a dirty
memory logging race that may cause live migration to fail.

Gleb Natapov (1):
      KVM: do not #GP on perf MSR writes when vPMU is disabled

Stephan Bärwolf (2):
      KVM: x86: extend "struct x86_emulate_ops" with "get_cpuid"
      KVM: x86: fix missing checks in syscall emulation

Takuya Yoshikawa (1):
      KVM: Fix __set_bit() race in mark_page_dirty() during dirty logging

 arch/x86/include/asm/kvm_emulate.h |   16 +++++++++++
 arch/x86/kvm/emulate.c             |   51
++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |   45 +++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                |    2 +-
 4 files changed, 113 insertions(+), 1 deletions(-)

-- 
error compiling committee.c: too many arguments to function

