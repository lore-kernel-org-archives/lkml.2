Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0IXALB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0IXALA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:11:00 -0400
Date: Thu, 23 Sep 2010 19:23:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for 2.6.36-rc5
Message-ID: <20100923222321.GA18212@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.36

To receive the following updates:

Avi Kivity (1):
      KVM: Fix reboot on Intel hosts

Michael S. Tsirkin (1):
      KVM: fix irqfd assign/deassign race

 virt/kvm/eventfd.c  |    3 ++-
 virt/kvm/kvm_main.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

