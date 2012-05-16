Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2EPP1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:27:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab2EPP1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:27:19 -0400
Date: Wed, 16 May 2012 12:22:20 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>
Subject: [GIT PULL] KVM fixes for 3.4-rc7
Message-ID: <20120516152220.GA19763@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive urgent KVM PPC updates, quoting Alexander Graf:

There are a few bugs in 3.4 that really should be fixed before people can
be all happy and fuzzy about KVM on PowerPC. These fixes are:

  * fix POWER7 bare metal with PR=y
  * fix deadlock on HV=y book3s_64 mode in low memory cases
  * fix invalid MMU scope of PR=y mode on book3s_64, possibly
    leading to memory corruption


Alexander Graf (3):
      KVM: PPC: Book3S: PR: Handle EMUL_ASSIST
      KVM: PPC: Fix PR KVM on POWER7 bare metal
      KVM: PPC: Book3S: PR: Fix hsrr code

Benjamin Herrenschmidt (1):
      powerpc/kvm: Fix VSID usage in 64-bit "PR" KVM

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix bug leading to deadlock in guest HPT updates

 arch/powerpc/include/asm/kvm_book3s.h |    7 +++--
 arch/powerpc/kvm/book3s_64_mmu_host.c |   13 +++++----
 arch/powerpc/kvm/book3s_hv_rm_mmu.c   |    1 +
 arch/powerpc/kvm/book3s_segment.S     |   42 ++++++++++++++++++++++-----------
 4 files changed, 40 insertions(+), 23 deletions(-)


