Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2HaSVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab2HaSVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:21:41 -0400
Date: Fri, 31 Aug 2012 14:06:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.6-rc3
Message-ID: <20120831170633.GA15082@amt.cnet>
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


Alan Cox (1):
      kvm: Fix nonsense handling of compat ioctl

Michael S. Tsirkin (1):
      KVM: x86: fix KVM_GET_MSR for PV EOI

 arch/x86/kvm/x86.c  |    3 +++
 virt/kvm/kvm_main.c |    7 ++++---
 2 files changed, 7 insertions(+), 3 deletions(-)
