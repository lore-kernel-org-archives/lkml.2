Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab2GEEOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 00:14:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab2GEEOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 00:14:39 -0400
Date: Thu, 5 Jul 2012 01:14:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.5-rc5
Message-ID: <20120705041418.GA20929@amt.cnet>
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

To receive the following KVM fixes: memory leak and oops on the x86 mmu code,
and sanitization of the KVM_IRQFD ioctl.


Alex Williamson (3):
      KVM: Pass kvm_irqfd to functions
      KVM: Add missing KVM_IRQFD API documentation
      KVM: Sanitize KVM_IRQFD flags

Xiao Guangrong (2):
      KVM: fix fault page leak
      KVM: MMU: fix shrinking page from the empty mmu

 Documentation/virtual/kvm/api.txt |   17 +++++++++++++++++
 arch/x86/kvm/mmu.c                |    3 +++
 include/linux/kvm_host.h          |    4 ++--
 virt/kvm/eventfd.c                |   23 +++++++++++++----------
 virt/kvm/kvm_main.c               |    3 ++-
 5 files changed, 37 insertions(+), 13 deletions(-)
