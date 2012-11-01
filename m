Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab2KAACT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 20:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab2KAACR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 20:02:17 -0400
Date: Wed, 31 Oct 2012 22:02:07 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.7-rc3
Message-ID: <20121101000207.GA6768@amt.cnet>
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


Xiao Guangrong (1):
      KVM: x86: fix vcpu->mmio_fragments overflow

 arch/x86/kvm/x86.c       |   60 ++++++++++++++++++++++++++---------------------
 include/linux/kvm_host.h |   15 +----------
 2 files changed, 36 insertions(+), 39 deletions(-)
