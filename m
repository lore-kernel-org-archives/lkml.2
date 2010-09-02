Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0IBPen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:34:43 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:58369
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518Ab0IBPel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:34:41 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz1454K4015Lzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L84LPI-01-728-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM fixes and cleanups
Date: Thu, 2 Sep 2010 17:29:44 +0200
Message-ID: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

here are 3 patches which came up during the final testing of the
nested-npt patch set. This patch set fixes two issues I found and the
last patch contains a minor cleanup which does not fix any real bug.
Please have a look at them and feel free to apply them (only if no
objections, of course ;-) )
For the bug that patch 2 fixes I will write a unit-test and submit it
separatly.

Thanks,
	Joerg

Shortlog:

Joerg Roedel (3):
      KVM: MMU: Fix 32 bit legacy paging with NPT
      KVM: SVM: Restore correct registers after sel_cr0 intercept emulation
      KVM: SVM: Clean up rip handling in vmrun emulation

Diffstat:

 arch/x86/kvm/mmu.c |    8 ++++++--
 arch/x86/kvm/svm.c |   39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 7 deletions(-)


