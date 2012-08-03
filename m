Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2HCSQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2HCSQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:16:36 -0400
Date: Fri, 3 Aug 2012 15:15:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.6-rc2
Message-ID: <20120803181524.GA19680@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following KVM _bug fixes_:

- Fix DS/ES segment register corruption on x86_32.
- Fix kvmclock wallclock migration offset.
- Fix PIT interrupt ACK vs system reset logic bug.



Avi Kivity (1):
      KVM: VMX: Fix ds/es corruption on i386 with preemption

Bruce Rogers (1):
      KVM: x86: apply kvmclock offset to guest wall clock time

Gleb Natapov (1):
      KVM: PIC: call ack notifiers for irqs that are dropped form irr


 arch/x86/kvm/i8259.c |   17 +++++++++++++++++
 arch/x86/kvm/vmx.c   |   20 +++++++++++++-------
 arch/x86/kvm/x86.c   |    4 ++++
 3 files changed, 34 insertions(+), 7 deletions(-)
