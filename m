Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab0KROzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:55:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513Ab0KROzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:55:24 -0500
Date: Thu, 18 Nov 2010 12:54:56 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 2.6.37-rc2
Message-ID: <20101118145455.GA13741@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

    git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37

To receive the following updates:

Avi Kivity (2):
      KVM: Correct ordering of ldt reload wrt fs/gs reload
      KVM: VMX: Fix host userspace gsbase corruption

 arch/x86/kvm/svm.c |    2 +-
 arch/x86/kvm/vmx.c |   19 +++++++++----------
 2 files changed, 10 insertions(+), 11 deletions(-)

