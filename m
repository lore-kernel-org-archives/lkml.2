Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2FXQRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 12:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2FXQRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 12:17:09 -0400
Message-ID: <4FE73D82.4040004@redhat.com>
Date: Sun, 24 Jun 2012 19:17:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 3.5-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull a couple of kvm fixes from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

Fixing a scheduling-while-atomic bug in the ppc code, and a bug which allowed
pci bridges to be assigned to guests.

----------------------------------------------------------------
Jan Kiszka (1):
      KVM: Fix PCI header check on device assignment

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Drop locks around call to kvmppc_pin_guest_page

 arch/powerpc/kvm/book3s_hv.c | 96 ++++++++++++++++++++++++++++++--------------
 virt/kvm/assigned-dev.c      |  4 +-
 2 files changed, 67 insertions(+), 33 deletions(-)

-- 
error compiling committee.c: too many arguments to function

