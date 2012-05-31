Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2EaAuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:50:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab2EaAui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:50:38 -0400
Date: Wed, 30 May 2012 21:44:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for v3.5
Message-ID: <20120531004452.GA3889@amt.cnet>
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

to receive a build fix for non-kvm archs and a transparent hugepage
refcount bugfix on hosts with 4M pages.


Avi Kivity (1):
      KVM: Export asm-generic/kvm_para.h

Xiao Guangrong (1):
      KVM: MMU: fix huge page adapted on non-PAE host

 arch/x86/kvm/mmu.c         |    3 +--
 include/asm-generic/Kbuild |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)


