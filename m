Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1BKSVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:21:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab1BKSVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:21:14 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] Steal time for KVM
Date: Fri, 11 Feb 2011 13:19:18 -0500
Message-Id: <1297448364-14051-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

This is the same series as before, adressing most of the concerns raised.
Please let me know if there is something else I should take into account here.

Thanks!

Glauber Costa (6):
  KVM-HDR: KVM Steal time implementation
  KVM-HV: KVM Steal time implementation
  KVM-GST: KVM Steal time accounting
  KVM-GST: KVM Steal time registration
  KVM-GST: adjust scheduler cpu power
  Describe KVM_MSR_STEAL_TIME

 Documentation/kvm/msr.txt       |   33 +++++++++++++++++
 arch/x86/Kconfig                |   12 ++++++
 arch/x86/include/asm/kvm_host.h |    5 +++
 arch/x86/include/asm/kvm_para.h |    9 +++++
 arch/x86/kernel/kvm.c           |   43 ++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c      |    2 +
 arch/x86/kvm/x86.c              |   39 +++++++++++++++++++-
 include/linux/kvm.h             |    1 +
 include/linux/sched.h           |    1 +
 kernel/sched.c                  |   77 ++++++++++++++++++++++++++++++++++-----
 kernel/sched_features.h         |    4 +-
 11 files changed, 212 insertions(+), 14 deletions(-)

-- 
1.7.2.3

