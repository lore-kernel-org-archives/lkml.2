Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3AHSGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:06:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab3AHSGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:06:14 -0500
Date: Tue, 8 Jan 2013 16:05:27 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.8-rc2
Message-ID: <20130108180527.GA24962@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: ~/inbox/sent-mutt-Aug-2012
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following KVM bug fixes


Alexander Graf (1):
      Merge commit 'origin/master' into kvm-ppc-3.8

Andreas Schwab (1):
      KVM: PPC: Book3S HV: Fix compilation without CONFIG_PPC_POWERNV

Bharat Bhushan (1):
      powerpc: Corrected include header path in kvm_para.h

Gleb Natapov (1):
      Merge branch 'kvm-ppc-3.8' of https://github.com/agraf/linux-2.6 into master

Li Zhong (1):
      Add rcu user eqs exception hooks for async page fault

Marcelo Tosatti (1):
      KVM: x86: use dynamic percpu allocations for shared msrs area

 arch/powerpc/include/uapi/asm/kvm_para.h |    2 +-
 arch/powerpc/kvm/book3s_hv_ras.c         |    4 ++++
 arch/x86/kernel/kvm.c                    |   12 ++++++++++--
 arch/x86/kvm/x86.c                       |   24 ++++++++++++++++++------
 4 files changed, 33 insertions(+), 9 deletions(-)
