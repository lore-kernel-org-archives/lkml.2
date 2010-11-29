Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0K2Pig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:38:36 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:19472 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0K2Pie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:38:34 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCNKS2-02-8UD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode
Date: Mon, 29 Nov 2010 16:38:07 +0100
Message-ID: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Hi Marcelo,

this patch-set introduces a generic notion of guest-mode for VCPUs in
KVM. This is already useful as seen in patch 3/3. Nested-VMX also has a
guest-mode, so it will make sense for this code too.

Regards,

	Joerg

As usual:

 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/kvm_cache_regs.h   |   15 +++++++++++++
 arch/x86/kvm/svm.c              |   44 ++++++++++++++++++--------------------
 arch/x86/kvm/x86.c              |   14 ++++++++---

Joerg Roedel (3):
      KVM: X86: Introduce generic guest-mode representation
      KVM: SVM: Make Use of the generic guest-mode functions
      KVM: X86: Don't report L2 emulation failures to user-space

 4 files changed, 47 insertions(+), 27 deletions(-)

