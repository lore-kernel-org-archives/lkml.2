Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab0GMRo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:44:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0GMRo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:44:28 -0400
Date: Tue, 13 Jul 2010 14:38:22 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for 2.6.35-rc4
Message-ID: <20100713173822.GA446@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.35

To receive the following updates:


Avi Kivity (1):
      KVM: VMX: Fix host MSR_KERNEL_GS_BASE corruption

Xiao Guangrong (1):
      KVM: MMU: flush remote tlbs when overwriting spte with different pfn

 arch/x86/kvm/mmu.c |    2 ++
 arch/x86/kvm/vmx.c |    7 ++-----
 2 files changed, 4 insertions(+), 5 deletions(-)

