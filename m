Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2KMBgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:36:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab2KMBgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:36:22 -0500
Date: Mon, 12 Nov 2012 23:36:15 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.7-rc5
Message-ID: <20121113013615.GA6963@amt.cnet>
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

To receive a correction for user triggerable oops

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-2012-4461)

 arch/x86/kvm/cpuid.h |    3 +++
 arch/x86/kvm/x86.c   |    3 +++
 2 files changed, 6 insertions(+)
