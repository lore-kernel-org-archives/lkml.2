Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab0JTPfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:35:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab0JTPff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:35:35 -0400
Date: Wed, 20 Oct 2010 13:31:58 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 2.6.36-rc8
Message-ID: <20101020153158.GA17457@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from 

    git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.36

To receive the fix for CVE-2010-3698.

Avi Kivity (1):
      KVM: Fix fs/gs reload oops with invalid ldt

 arch/x86/include/asm/kvm_host.h |   24 ------------------------
 arch/x86/kvm/svm.c              |   15 ++++++++++-----
 arch/x86/kvm/vmx.c              |   24 +++++++++---------------
 3 files changed, 19 insertions(+), 44 deletions(-)

