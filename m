Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2DSLnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab2DSLnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:43:31 -0400
Date: Thu, 19 Apr 2012 08:39:23 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for 3.4.0-rc3
Message-ID: <20120419113923.GA14324@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Linus, please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following updates

Alex Williamson (2):
      KVM: unmap pages from the iommu when slots are removed
      KVM: lock slots_lock around device assignment

Avi Kivity (1):
      KVM: VMX: Fix kvm_set_shared_msr() called in preemptible context

Gleb Natapov (1):
      KVM: PMU emulation: GLOBAL_CTRL MSR should be enabled on reset


 arch/x86/kvm/pmu.c       |   18 +++++++++---------
 arch/x86/kvm/vmx.c       |    5 ++++-
 include/linux/kvm_host.h |    6 ++++++
 virt/kvm/iommu.c         |   30 +++++++++++++++++++++---------
 virt/kvm/kvm_main.c      |    5 +++--
 5 files changed, 43 insertions(+), 21 deletions(-)


