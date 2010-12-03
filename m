Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab0LCOZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:25:38 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:36613
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758454Ab0LCOZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:25:35 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCUW28-02-9EX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] KVM: SVM: Add support Flush-By-ASID feature
Date: Fri, 3 Dec 2010 15:25:13 +0100
Message-ID: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Hi Marcelo,

here is the patch-set to add support for the Flush-By-ASID feature to
KVM on AMD. Patches 1 and 2 clean up the code a little bit and patch 3
implements the feature itself.

Regards,

	Joerg

 arch/x86/include/asm/svm.h |    2 ++
 arch/x86/kvm/svm.c         |   32 ++++++++++++++------------------
 2 files changed, 16 insertions(+), 18 deletions(-)

Joerg Roedel (3):
      KVM: SVM: Remove flush_guest_tlb function
      KVM: SVM: Use svm_flush_tlb instead of force_new_asid
      KVM: SVM: Implement Flush-By-Asid feature


