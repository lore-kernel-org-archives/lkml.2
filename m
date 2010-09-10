Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0IJOju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0IJOjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:39:49 -0400
Date: Fri, 10 Sep 2010 11:29:20 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for 2.6.36-rc3
Message-ID: <20100910142920.GA21178@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.36

To receive the following updates:

Avi Kivity (2):
      KVM: x86 emulator: fix regression with cmpxchg8b on i386 hosts
      KVM: fix i8259 oops when no vcpus are online

Gleb Natapov (1):
      KVM: i8259: fix migration

Zachary Amsden (1):
      KVM: x86: Perform hardware_enable in CPU_STARTING callback


 arch/x86/include/asm/kvm_emulate.h |    7 ++++++-
 arch/x86/kvm/emulate.c             |    9 ++++-----
 arch/x86/kvm/i8259.c               |    3 +++
 arch/x86/kvm/irq.h                 |    2 +-
 virt/kvm/kvm_main.c                |    5 ++---
 5 files changed, 16 insertions(+), 10 deletions(-)

