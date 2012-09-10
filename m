Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2IJPea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:34:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab2IJPe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:34:28 -0400
Message-ID: <504E0881.7030101@redhat.com>
Date: Mon, 10 Sep 2012 18:34:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates for 3.6-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and branch at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.6-2

to receive a trio of KVM fixes: incorrect lookup of guest cpuid,
an uninitialized variable fix, and error path cleanup fix.

Shortlog/diffstat follow.

----------------------------------------------------------------
KVM updates for 3.6-rc5

----------------------------------------------------------------
Jamie Iles (1):
      KVM: PIC: fix use of uninitialised variable.

Ren, Yongjie (1):
      KVM: x86: Check INVPCID feature bit in EBX of leaf 7

Xiao Guangrong (1):
      KVM: fix error paths for failed gfn_to_page() calls

 arch/x86/kvm/i8259.c |  2 +-
 arch/x86/kvm/vmx.c   | 23 ++++++++++++++++++-----
 arch/x86/kvm/x86.c   | 13 ++++++++++---
 3 files changed, 29 insertions(+), 9 deletions(-)

-- 
error compiling committee.c: too many arguments to function
